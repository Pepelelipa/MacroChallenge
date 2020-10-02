//
//  NotesViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesViewController: UIViewController, TextEditingDelegateObserver {
    
    internal var textBoxes: Set<TextBoxView> = []    

    internal private(set) weak var note: NoteEntity?  
        
    private var resizeHandles = [ResizeHandleView]()
    private var initialCenter = CGPoint()
    private var scale: CGFloat = 1.0
    private var currentBoxViewPosition: CGPoint = .zero
    
    private lazy var imageButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "imageButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var btnBack: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .actionColor

        return btn
    }()
    
    public var isBtnBackHidden: Bool {
        get {
            return btnBack.isHidden
        }
        set {
            btnBack.isHidden = newValue
        }
    }
    
    internal lazy var textView: MarkupTextView = MarkupTextView(frame: .zero, delegate: self.textViewDelegate)
    
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
    
    private lazy var textViewDelegate: MarkupTextViewDelegate? = {
        let delegate = MarkupTextViewDelegate()
        delegate.observer = self
        DispatchQueue.main.async {
            delegate.markdownAttributesChanged = { [unowned self](attributtedString, error) in
                if let error = error {
                    NSLog("Error requesting -> \(error)")
                    return
                }

                guard let attributedText = attributtedString else {
                    NSLog("No error nor string found")
                    return
                }

                self.textView.attributedText = attributedText
            }
            delegate.parsePlaceholder(on: self.textView)
        }
        return delegate
    }()
    
    private lazy var keyboardToolbar: MarkupToolBar = MarkupToolBar(frame: .zero, owner: textView, controller: self)
    
    internal init(note: NoteEntity) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        self.textField.attributedText = note.title
    }

    internal convenience required init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity else {
            return nil
        }
        self.init(note: note)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btnBack)
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .phone {
            btnBack.isHidden = UIDevice.current.orientation.isLandscape
        } else if dev == .pad {
            btnBack.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        view.addGestureRecognizer(tap)
        view.addSubview(textField)
        view.addSubview(textView)
        view.addSubview(imageButton)
        self.view.backgroundColor = .backgroundColor
        
        textView.inputAccessoryView = keyboardToolbar
    }
    
    public override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            imageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50 + btnBack.frame.height),
            textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func textEditingDidBegin() {
        DispatchQueue.main.async {
            self.textBoxes.forEach { (textBox) in
                textBox.state = .idle
                textBox.markupTextView.isUserInteractionEnabled = false
            }
            self.imageButton.isHidden = true
            
            if !self.resizeHandles.isEmpty {
                self.resizeHandles.forEach { (resizeHandle) in
                    resizeHandle.removeFromSuperview()
                }
            }
        }
    }
    
    func textEditingDidEnd() {
        DispatchQueue.main.async {
            self.imageButton.isHidden = false
        }
    }
    
    /**
     Create a text box
     - Parameters
        - frame: The text box frame.
     */
    func addTextBox(with frame: CGRect) {
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
     Uptade the resize handle position and the border of the text box.
     */
    func uptadeResizeHandles() {
        resizeHandles.forEach { (handle) in
            handle.updatePosition()
        }
        textBoxes.forEach { (textBox) in
            textBox.setUpBorder()
        }
    }
    
    /**
     Adds and positions the resize handles in the box view
     - Parameters
        - boxView: The Box View who will receive the resize handle.
     */
    func placeResizeHandles(boxView: BoxView) {
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
     Updates the position of the resize handles.
     */
    func updateResizeHandles() {
        resizeHandles.forEach { (resizeHandle) in
            resizeHandle.updatePosition()
        }
    }
    
    /**
     Move the box view and uptade their resize handles position.
     - Parameters
        - boxView: The Box View who will be moved.
        - vector: The new position of the box view.
     */
    func moveBoxView(boxView: BoxView, by vector: CGPoint) {
        boxView.center = currentBoxViewPosition + vector
        uptadeResizeHandles()
    }
    
    ///Go back to the previous step(opens the notebook index) according to the device and orientation
    @IBAction func btnBackTap(_ sender: UIButton) {
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .pad {
            splitViewController?.preferredDisplayMode = .oneOverSecondary
        } else {
            if UIDevice.current.orientation.isLandscape {
                splitViewController?.preferredDisplayMode = .oneOverSecondary
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
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
