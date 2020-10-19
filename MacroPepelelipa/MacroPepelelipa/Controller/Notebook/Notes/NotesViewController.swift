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
    
    private lazy var keyboardToolbar: MarkupToolBar = {
        let toolBar = MarkupToolBar(frame: .zero, configurations: markupConfig)
        return toolBar
    }()
     
    internal lazy var textViewDelegate: MarkupTextViewDelegate = {
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
    
    internal lazy var markupConfig: MarkupBarConfiguration = {
        let mrkConf = MarkupBarConfiguration(owner: textView)
        mrkConf.observer = self
        return mrkConf
    }()
        
    internal private(set) lazy var textView: MarkupTextView = MarkupTextView(frame: .zero, delegate: self.textViewDelegate)
    
    internal private(set) lazy var formatViewDelegate: MarkupFormatViewDelegate? = {
        return MarkupFormatViewDelegate(viewController: self)
    }()
    
    internal private(set) lazy var markupContainerView: MarkupContainerView = {
        let height: CGFloat = screenHeight/4
        
        let container = MarkupContainerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height), owner: self.textView, delegate: self.formatViewDelegate, viewController: self)
        
        container.autoresizingMask = []
        container.isHidden = true
        container.delegate = self.formatViewDelegate
        
        return container
    }()

    private lazy var constraints: [NSLayoutConstraint] = {
        [
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
    }()
    
    // MARK: - Initializers
    
    internal init(note: NoteEntity) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        
        do {
            self.notebook = try note.getNotebook()
        } catch {
            let alertController = UIAlertController(
                title: "Error retriving notebook".localized(),
                message: "The app could not retrieve a notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "A notebook could not be retrieved".localized())

            self.present(alertController, animated: true, completion: nil)
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

        self.textField.attributedText = note?.title
        self.textView.attributedText = note?.text
        for textBox in note?.textBoxes ?? [] {
            addTextBox(with: textBox)
        }
        for imageBox in note?.images ?? [] {
            addImageBox(with: imageBox)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveNote()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
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
     Delete all resize handles
     */
    private func cleanResizeHandles() {
        if !resizeHandles.isEmpty {
            resizeHandles.forEach { (resizeHandle) in
                resizeHandle.removeFromSuperview()
            }
            resizeHandles.removeAll()
        }
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
    
    private func saveNote() {
        do {
            guard let note = note else {
                return
            }
            note.title = textField.attributedText ?? NSAttributedString(string: "Lesson".localized())
            note.text = textView.attributedText ?? NSAttributedString()
            for textBox in textBoxes where textBox.frame.origin.x != 0 && textBox.frame.origin.y != 0 {
                if let entity = note.textBoxes.first(where: { $0 === textBox.entity }) {
                    entity.text = textBox.markupTextView.attributedText
                    entity.x = Float(textBox.frame.origin.x)
                    entity.y = Float(textBox.frame.origin.y)
                    entity.z = Float(textBox.layer.zPosition)
                    entity.width = Float(textBox.frame.width)
                    entity.height = Float(textBox.frame.height)
                }
            }

            for imageBox in imageBoxes where imageBox.frame.origin.x != 0 && imageBox.frame.origin.y != 0 {
                if let entity = note.images.first(where: { $0 === imageBox.entity }) {
                    entity.x = Float(imageBox.frame.origin.x)
                    entity.y = Float(imageBox.frame.origin.y)
                    entity.z = Float(imageBox.layer.zPosition)
                    entity.width = Float(imageBox.frame.width)
                    entity.height = Float(imageBox.frame.height)
                }
            }
            try note.save()
        } catch {
            let alertController = UIAlertController(
                title: "Error saving the notebook".localized(),
                message: "The database could not save the notebook".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "The Notebook could not be saved".localized())
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    ///Uptade the resize handle position and the border of the text box.
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
     Adds a Text Box
     */
    func addTextBox(with textBoxEntity: TextBoxEntity) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressInTextBox(_:)))

        let textBox = TextBoxView(textBoxEntity: textBoxEntity, owner: textView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            textBox.markupTextView.attributedText = textBoxEntity.text
        }
        textBox.addGestureRecognizer(tapGesture)
        textBox.addGestureRecognizer(doubleTapGesture)
        textBox.addGestureRecognizer(panGesture)
        textBox.addGestureRecognizer(longPressGesture)
        self.textBoxes.insert(textBox)
        self.textView.addSubview(textBox)
    }
    
    ///Creates an Image Box
    func createImageBox(image: UIImage?) {
        do {
            guard let image = image,
                  let note = note else {
                let alertController = UIAlertController(
                    title: "Note do not exist".localized(),
                    message: "The app could not safe unwrap the view controller note".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "Failed to load the Note".localized())

                self.present(alertController, animated: true, completion: nil)
                return
            }

            let path = try FileHelper.saveToFiles(image: image)
            let imageBoxEntity = try DataManager.shared().createImageBox(in: note, at: path)
            imageBoxEntity.x = Float(view.frame.width/2)
            imageBoxEntity.y = 10
            imageBoxEntity.width = 150
            imageBoxEntity.height = 150

            addImageBox(with: imageBoxEntity)
        } catch {
            let alertController = UIAlertController(
                title: "Failed to create a Image Box".localized(),
                message: "The app could not create a Image Box".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "Failed to create a Image Box".localized())

            self.present(alertController, animated: true, completion: nil)
        }
    }

    ///Adds an Image Box
    func addImageBox(with imageBoxEntity: ImageBoxEntity) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressInImageBox(_:)))

        if let fileName = FileHelper.getFilePath(fileName: imageBoxEntity.imagePath) {
            let image = UIImage(contentsOfFile: fileName)
            let imageBox = ImageBoxView(imageBoxEntity: imageBoxEntity, owner: textView, image: image)

            imageBox.addGestureRecognizer(tapGesture)
            imageBox.addGestureRecognizer(doubleTapGesture)
            imageBox.addGestureRecognizer(panGesture)
            imageBox.addGestureRecognizer(longPressGesture)
            self.imageBoxes.insert(imageBox)
            self.textView.addSubview(imageBox)
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
    
    // MARK: - TextEditingDelegateObserver functions
    
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
        saveNote()
    }
    
    // MARK: - MarkupToolBarObserver functions
    
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
    
    ///Creates a TextBox
    func createTextBox(transcription: String? = nil) {
        do {
            guard let note = note else {
                let alertController = UIAlertController(
                    title: "Note do not exist".localized(),
                    message: "The app could not safe unwrap the view controller note".localized(),
                    preferredStyle: .alert)
                    .makeErrorMessage(with: "Failed to load the Note".localized())

                self.present(alertController, animated: true, completion: nil)
                return
            }
            let textBoxEntity = try DataManager.shared().createTextBox(in: note)
            textBoxEntity.x = Float(view.frame.width/2)
            textBoxEntity.y = 10
            textBoxEntity.height = 40
            textBoxEntity.width = 140
            if let transcriptedText = transcription {
                textBoxEntity.text = NSAttributedString(string: transcriptedText)
            } else {
                textBoxEntity.text = NSAttributedString(string: "Text".localized())
            }
            addTextBox(with: textBoxEntity)
        } catch {
            let alertController = UIAlertController(
                title: "Failed to create a Text Box".localized(),
                message: "The app could not create a Text Box".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "Failed to create a Text Box".localized())

            self.present(alertController, animated: true, completion: nil)
        }
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
    
    // MARK: - PHPickerViewControllerDelegate functions
    
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
                    guard let image = loadedImage as? UIImage else {
                        return
                    }
                    
                    let alert = UIAlertController(title: "Image or text?".localized(), 
                                                  message: "Import the media as an image or as a text transcription (Beta version)".localized(), 
                                                  preferredStyle: .alert)
                    
                    let importImageAction = UIAlertAction(title: "Image".localized(), style: .default) { (_) in
                        self?.createImageBox(image: image)
                    }
                    
                    let importTextAction = UIAlertAction(title: "Text".localized(), style: .default) { (_) in
                        
                        let textRecognition = TextRecognitionManager()
                        let transcription = textRecognition.imageRequest(toImage: image)
                        
                        self?.createTextBox(transcription: transcription)
                    }
                    
                    alert.view.tintColor = .actionColor
                    
                    alert.addAction(importImageAction)
                    alert.addAction(importTextAction)
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            }
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
    
    @IBAction private func handleLongPressInImageBox(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard let boxView = gestureRecognizer.view as? ImageBoxView, let entity = boxView.entity else {
            return
        }
        
        if gestureRecognizer.state == .began {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .imageBox, deletionHandler: { _ in
                let deleteAlertController = UIAlertController(title: "Delete Image Box confirmation".localized(),
                                                              message: "Warning".localized(),
                                                              preferredStyle: .alert).makeDeleteConfirmation(dataType: .imageBox, deletionHandler: { _ in
                                                                do {
                                                                    boxView.removeFromSuperview()
                                                                    self.imageBoxes.remove(boxView)
                                                                    self.cleanResizeHandles()
                                                                    _ = try DataManager.shared().deleteImageBox(entity)
                                                                } catch {
                                                                    let alertController = UIAlertController(
                                                                        title: "Could not delete this Image Box".localized(),
                                                                        message: "The app could not delete the image box".localized(),
                                                                        preferredStyle: .alert)
                                                                        .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                }
                                                              })
                self.present(deleteAlertController, animated: true, completion: nil)
            })

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func handleLongPressInTextBox(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard let boxView = gestureRecognizer.view as? TextBoxView, let entity = boxView.entity else {
            return
        }
        
        if gestureRecognizer.state == .began {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .textBox, deletionHandler: { _ in
                let deleteAlertController = UIAlertController(title: "Delete Text Box confirmation".localized(),
                                                              message: "Warning".localized(),
                                                              preferredStyle: .alert).makeDeleteConfirmation(dataType: .textBox, deletionHandler: { _ in
                                                                do {
                                                                    boxView.removeFromSuperview()
                                                                    self.textBoxes.remove(boxView)
                                                                    self.cleanResizeHandles()
                                                                    _ = try DataManager.shared().deleteTextBox(entity)
                                                                } catch {
                                                                    let alertController = UIAlertController(
                                                                        title: "Could not delete this Text Box".localized(),
                                                                        message: "The app could not delete the text box".localized(),
                                                                        preferredStyle: .alert)
                                                                        .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                }
                                                              })
                self.present(deleteAlertController, animated: true, completion: nil)
            })

            self.present(alertController, animated: true, completion: nil)
        }
    }
}
