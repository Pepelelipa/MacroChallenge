//
//  NotesViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina and 
//             Leonardo Amorim de Oliveira on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import PhotosUI

internal class NotesViewController: UIViewController, 
                                    TextEditingDelegateObserver,
                                    MarkupToolBarObserver,
                                    PHPickerViewControllerDelegate {
    
    // MARK: - Variables and Constants
    
    private var resizeHandles = [ResizeHandleView]()
    private var initialCenter = CGPoint()
    private var scale: CGFloat = 1.0
    private var currentBoxViewPosition: CGPoint = .zero
    private var libraryImage: UIImage?

    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    internal var textBoxes: Set<TextBoxView> = []  
    internal var imageBoxes: Set<ImageBoxView> = []
    internal var imgeButtonObserver: ImageButtonObserver?
    
    internal weak var note: NoteEntity?
    internal private(set) weak var notebook: NotebookEntity?
    
    internal private(set) lazy var markupContainerView: MarkupContainerView = {
        let height: CGFloat = screenHeight/4
        
        let container = MarkupContainerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height), owner: self.textView, delegate: self.formatViewDelegate, viewController: self)
        
        container.autoresizingMask = []
        container.isHidden = true
        container.delegate = self.formatViewDelegate
        
        return container
    }()
    
    private lazy var textField: MarkupTextField = {
        let textField = MarkupTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
        textField.delegate = self.textFieldDelegate
        return textField
    }()
    
    private lazy var textFieldDelegate: MarkupTextFieldDelegate = {
        let delegate = MarkupTextFieldDelegate()
        delegate.observer = self
        return delegate
    }()
     
    private lazy var textViewDelegate: MarkupTextViewDelegate = {
        let delegate = MarkupTextViewDelegate()
        delegate.addObserver(self)
        return delegate
    }()
    
    internal lazy var workItem = DispatchWorkItem {
        self.textViewDelegate.markdownAttributesChanged = { [weak self] (attributtedString, error) in
            if let error = error {
                NSLog("Error requesting -> \(error)")
                return
            }

            guard let attributedText = attributtedString else {
                NSLog("No error nor string found")
                return
            }
            if self?.textView.text == "",
               let textView = self?.textView {
                self?.textViewDelegate.parsePlaceholder(on: textView)
            }
        }
        self.textViewDelegate.parsePlaceholder(on: self.textView)
    }
    
    private lazy var markupNavigationView: MarkupNavigationView = {
       let mrkView = MarkupNavigationView(frame: CGRect(x: 600, y: 50, width: 200, height: 30), configurations: markupConfig)
        mrkView.backgroundColor = UIColor.backgroundColor
        
        return mrkView
    }()
    
    private lazy var markupConfig: MarkupBarConfiguration = {
        let mrkConf = MarkupBarConfiguration(owner: textView)
        mrkConf.observer = self
        return mrkConf
    }()
    
    private lazy var keyboardToolbar: MarkupToolBar = {
        let toolBar = MarkupToolBar(frame: .zero, configurations: markupConfig)
        return toolBar
    }()
    
    internal private(set) lazy var textView: MarkupTextView = MarkupTextView(frame: .zero, delegate: self.textViewDelegate)
    
    internal private(set) lazy var formatViewDelegate: MarkupFormatViewDelegate? = {
        return MarkupFormatViewDelegate(viewController: self)
    }()
    
    // MARK: - Initializers
    
    internal init(note: NoteEntity) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        self.textField.attributedText = note.title
        self.textView.attributedText = note.text
        
        do {
            self.notebook = try note.getNotebook()
        } catch {
            fatalError("Error retriving notebook")
        }
    }
    
    deinit {
        textViewDelegate.removeObserver(self)
    }

    internal convenience required init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity else {
            return nil
        }
        self.init(note: note)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        view.addGestureRecognizer(tap)
        view.addSubview(markupContainerView)
        view.addSubview(textField)
        view.addSubview(textView)
        self.view.backgroundColor = .backgroundColor
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            textView.inputAccessoryView = keyboardToolbar
            formatViewDelegate?.setFormatView(markupContainerView)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            textView.inputAccessoryView = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        do {
            note?.title = textField.attributedText ?? NSAttributedString(string: "Lesson".localized())
            note?.text = textView.attributedText ?? NSAttributedString()
            try note?.save()
        } catch {
            fatalError("Ops")
        }
    }
    
    override func viewDidLayoutSubviews() {

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Functions
    
    /**
     Create a Image Box
     - Parameters
        - frame: The text box frame.
        - Image: The image displayed on Image Box.
     */
    private func addImageBox(with frame: CGRect, image: UIImage) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        
        let imageBox = ImageBoxView(frame: frame, owner: textView, image: image)
        
        imageBox.addGestureRecognizer(tapGesture)
        imageBox.addGestureRecognizer(doubleTapGesture)
        imageBox.addGestureRecognizer(panGesture)
        imageBox.addGestureRecognizer(pinchGesture)
        self.imageBoxes.insert(imageBox)
        self.textView.addSubview(imageBox)
    }
    
    /**
     Adds and position the resize handles in the box view
     - Parameters
        - boxView: The Box View who will receive the resize handle.
     */
    private func placeResizeHandles(boxView: BoxView) {
        if !resizeHandles.isEmpty {
            resizeHandles.forEach { (resizeHandle) in
                resizeHandle.removeFromSuperview()
            }
            resizeHandles.removeAll()
        }
        ResizeHandleView.createResizeHandleView(on: boxView, handlesArray: &resizeHandles, inside: self)
        resizeHandles[0].setNeedsDisplay()
    }
    
    /**
     Move the box view and uptade their resize handles position.
     - Parameters
        - boxView: The Box View who will be moved.
        - vector: The new position of the box view.
     */
    private func moveBoxView(boxView: BoxView, by vector: CGPoint) {
        boxView.center = currentBoxViewPosition + vector
        uptadeResizeHandles()
    }
    
    /**
     Uptade the resize handle position and the border of the text box.
     */
    internal func uptadeResizeHandles() {
        resizeHandles.forEach { (handle) in
            handle.updatePosition()
        }
        textBoxes.forEach { (textBox) in
            textBox.setUpBorder()
        }
        imageBoxes.forEach { (imageBox) in
            imageBox.setUpBorder()
        }
    }
    
    /**
     This method changes de main input view based on it being custom or not.
     - Parameter isCustom: A boolean indicating if the input view will be a custom view or not.
     */
    internal func changeTextViewInput(isCustom: Bool) {
        if isCustom == true {
            textView.inputView = markupContainerView
        } else {
            textView.inputView = nil
        }
        
        keyboardToolbar.isHidden.toggle()
        markupContainerView.isHidden.toggle()
        textView.reloadInputViews()
    }
    
    /**
     This method opens the pop over when the button is pressed
     */
    internal func openPopOver() {
        let markupContainerViewController = MarkupContainerViewController(owner: textView, 
                                                                          delegate: formatViewDelegate, 
                                                                          viewController: self, 
                                                                          size: .init(width: 380, height: 110))
        
        if let formatView = markupContainerViewController.formatView {
            formatViewDelegate?.setFormatView(formatView)
            textViewDelegate.setFotmatView(formatView)
        }
        
        markupContainerViewController.modalPresentationStyle = .popover
        markupContainerViewController.popoverPresentationController?.sourceView = markupNavigationView.barButtonItems[4]
        
        present(markupContainerViewController, animated: true)
    }
    
    func textEditingDidBegin() {
        DispatchQueue.main.async {
            self.textBoxes.forEach { (textBox) in
                textBox.state = .idle
                textBox.markupTextView.isUserInteractionEnabled = false
            }
            self.imageBoxes.forEach { (imageBox) in
                imageBox.state = .idle
            }
            self.imgeButtonObserver?.hideImageButton()
            
            if !self.resizeHandles.isEmpty {
                self.resizeHandles.forEach { (resizeHandle) in
                    resizeHandle.removeFromSuperview()
                }
            }
        }
    }
    
    func textEditingDidEnd() {
        DispatchQueue.main.async {
            self.imgeButtonObserver?.showImageButton()
        }
    }
    
    /**
     Create a Text Box
     - Parameters
        - frame: The text box frame.
     */
    internal func addTextBox(with frame: CGRect) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        
        let textBox = TextBoxView(frame: frame, owner: textView)
        
        textBox.addGestureRecognizer(tapGesture)
        textBox.addGestureRecognizer(doubleTapGesture)
        textBox.addGestureRecognizer(panGesture)
        textBox.addGestureRecognizer(pinchGesture)
        self.textBoxes.insert(textBox)
        self.textView.addSubview(textBox)
    }
    
    /**
     Present the native Image Picker. There we instantiate a PHPickerViewController and set its delegate. Finally, there is a present from the view controller.
     */
    internal func presentPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
                
        let picker = PHPickerViewController(configuration: config)
        
        picker.delegate = self

        present(picker, animated: true, completion: nil)   
    }
    
    internal func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (loadedImage, error) in
                
                if let error = error, let self = self {
                    let alertController = UIAlertController(
                        title: "Error presenting Photo Library".localized(),
                        message: "The app could not present the Photo Library".localized(),
                        preferredStyle: .alert)
                        .makeErrorMessage(with: "The app could not load the native Image Picker Controller".localized())
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                    NSLog("Error requesting -> \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    guard let self = self, let image = loadedImage as? UIImage else {
                        return
                    }
                    let frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
                    self.addImageBox(with: frame, image: image)
                }
            }
        }
    }
    
    /**
     Updates the position of the resize handles.
     */
    internal func updateResizeHandles() {
        resizeHandles.forEach { (resizeHandle) in
            resizeHandle.updatePosition()
        }
    }
    
    // MARK: - IBActions functions
    
    @IBAction func didTap() {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    
    @IBAction private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if let boxView = gestureRecognizer.view as? BoxView {
            boxView.state = .editing
            placeResizeHandles(boxView: boxView)            
            boxView.owner.endEditing(true)
        } 
    }
    
    @IBAction private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if let textBox = gestureRecognizer.view as? TextBoxView {
            textBox.markupTextView.isUserInteractionEnabled = true
            textBox.markupTextView.becomeFirstResponder()
        }
    }

    @IBAction private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let boxView = gestureRecognizer.view as? BoxView else {
            return
        }
        if boxView.state == .editing {
            let translation = gestureRecognizer.translation(in: self.textView)
            if gestureRecognizer.state == .began {                
                initialCenter = boxView.center
            }
            if gestureRecognizer.state != .cancelled {
                let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
                moveBoxView(boxView: boxView, by: newCenter)
            } else {
                boxView.center = initialCenter
            }
            if gestureRecognizer.state == .ended {
                let exclusionPath  = UIBezierPath(rect: boxView.frame)
                self.textView.textContainer.exclusionPaths = [exclusionPath]
            }
        }
    }
    
    @IBAction private func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let boxView = gestureRecognizer.view as? BoxView else {
            return
        }
        
        if boxView.state == .editing, gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            boxView.transform = CGAffineTransform(scaleX: scale + gestureRecognizer.scale, y: scale + gestureRecognizer.scale)
            
            if gestureRecognizer.scale < 0.5 {
                gestureRecognizer.scale = 1
            } else if gestureRecognizer.scale > 3 {
                gestureRecognizer.scale = 3
            }
            
            scale = gestureRecognizer.scale
        }
    }
}
