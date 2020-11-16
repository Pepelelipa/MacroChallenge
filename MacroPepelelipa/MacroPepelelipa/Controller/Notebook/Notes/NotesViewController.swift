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
import MarkdownText

#if targetEnvironment(macCatalyst)
import AppKit
#endif

internal class NotesViewController: UIViewController, 
                                    TextEditingDelegateObserver,
                                    MarkupToolBarObserver,
                                    MarkdownFormatViewReceiver,
                                    ResizeHandleReceiver {
    
    // MARK: - Variables and Constants
    
    #if !targetEnvironment(macCatalyst)
    private static let boldfaceKeyCommand: UIKeyCommand = {
        let command = UIKeyCommand(input: "B", modifierFlags: .command, action: #selector(toggleFormat(_:)))
        command.discoverabilityTitle = "Bold".localized()
        return command
    }()
    
    private static let italicsKeyCommand: UIKeyCommand = {
        let command = UIKeyCommand(input: "I", modifierFlags: .command, action: #selector(toggleFormat(_:)))
        command.discoverabilityTitle = "Italic".localized()
        return command
    }()
    
    static let underlineKeyCommand: UIKeyCommand = {
        let command = UIKeyCommand(input: "U", modifierFlags: .command, action: #selector(toggleFormat(_:)))
        command.discoverabilityTitle = "Underline".localized()
        return command
    }()
    
    #else
    internal static let importCommand: UICommand = {
        return UICommand(title: "Import image".localized(), image: nil, action: #selector(importImage), propertyList: nil, alternates: [], discoverabilityTitle: "Import image".localized())
    }()
    
    internal static let exportNoteCommand: UICommand = {
        return UICommand(title: "Export note as PDF".localized(), image: nil, action: #selector(exportNote), propertyList: nil, alternates: [], discoverabilityTitle: "Export note as PDF".localized())
    }()

    internal static let exportNotebookCommand: UICommand = {
        return UICommand(title: "Export notebook as PDF".localized(),
                         image: nil,
                         action: #selector(exportNotebook),
                         propertyList: nil,
                         alternates: [],
                         discoverabilityTitle: "Export notebook as PDF".localized())
    }()
    
    private lazy var documentPickerDelegate: DocumentPickerDelegate = {
        return DocumentPickerDelegate { image in
            self.addMedia(from: image)
        }
    }()
    #endif
    
    private var resizeHandles = [ResizeHandleView]()
    private var initialCenter = CGPoint()
    private var scale: CGFloat = 1.0
    private var currentBoxViewPosition: CGPoint = .zero
    private var libraryImage: UIImage?
    private var exclusionPaths: [UIBezierPath] = []
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    internal var shouldSave: Bool = true
    internal var textBoxes: Set<TextBoxView> = []  
    internal var imageBoxes: Set<ImageBoxView> = []
    internal var imgeButtonObserver: ImageButtonObserver?
    internal lazy var receiverView: UIView = self.view
    
    internal weak var note: NoteEntity?
    internal var delegate: AppMarkdownTextViewDelegate?
    internal private(set) weak var notebook: NotebookEntity?
    
    private lazy var textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    
    private lazy var textField: MarkdownTextField = {
        let textField = MarkdownTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
        textField.delegate = self.textFieldDelegate
        textField.accessibilityLabel = "Note title".localized()
        textField.accessibilityHint = "Note title hint".localized()
        return textField
    }()
    
    private lazy var textFieldDelegate: MarkupTextFieldDelegate = {
        let delegate = MarkupTextFieldDelegate()
        delegate.observer = self
        return delegate
    }()
    
    private lazy var keyboardToolbar: MarkdownToolBar = {
        let toolBar = MarkdownToolBar(frame: .zero, configurations: markupConfig)
        return toolBar
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 30),
            
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textViewBottomConstraint
        ]
    }()
    
    internal private(set) lazy var textView: MarkdownTextView = {
        let  markdownTextView = MarkdownTextView(frame: .zero)
        self.delegate = AppMarkdownTextViewDelegate()
        delegate?.addTextObserver(self)
        markdownTextView.markdownDelegate = delegate
        markdownTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        markdownTextView.accessibilityLabel = "Note".localized()
        return markdownTextView
    }()
    
    internal lazy var markupConfig: MarkdownBarConfiguration = {
        let mrkConf = MarkdownBarConfiguration(owner: textView)
        mrkConf.observer = self
        return mrkConf
    }()
    
    internal private(set) lazy var markupContainerView: MarkdownContainerView = {
        let height: CGFloat = screenHeight/4
        
        let container = MarkdownContainerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height), owner: self.textView, receiver: self)
        
        container.autoresizingMask = []
        container.isHidden = true
        
        return container
    }()
    
    private lazy var dropInteractionDelegate: DropInteractionDelegate = DropInteractionDelegate(viewController: self)
    
    #if !targetEnvironment(macCatalyst)
    internal lazy var photoPickerDelegate = PhotoPickerDelegate { (image, error) in
        if let error = error {
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
        if let image = image {
            self.addMedia(from: image)
        }
    }
    
    internal lazy var imagePickerDelegate = ImagePickerDelegate { (image) in
        if let image = image {
            self.addMedia(from: image)
        }
    }
    #endif
    
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
        //        textViewDelegate.removeObserver(self)
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity else {
            return nil
        }
        self.init(note: note)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        textView.placeholder = "Start writing here".localized()
        super.viewDidLoad()
        
        #if !targetEnvironment(macCatalyst)
        addKeyCommand(NotesViewController.boldfaceKeyCommand)
        addKeyCommand(NotesViewController.italicsKeyCommand)
        addKeyCommand(NotesViewController.underlineKeyCommand)
        #endif
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        view.addGestureRecognizer(tap)
        view.addSubview(markupContainerView)
        view.addSubview(textField)
        view.addSubview(textView)
        self.view.backgroundColor = .backgroundColor
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            textView.inputAccessoryView = keyboardToolbar
        } else if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            textView.inputAccessoryView = nil
        }
        
        if note?.title.string != "" {
            self.textField.attributedText = note?.title
        }
        if note?.text.string != "" {
            self.textView.attributedText = note?.text
        }
        for textBox in note?.textBoxes ?? [] {
            addTextBox(with: textBox)
        }
        for imageBox in note?.images ?? [] {
            addImageBox(with: imageBox)
        }
        updateExclusionPaths()
        
        if !((try? notebook?.getWorkspace().isEnabled) ?? false) {
            textView.isEditable = false
            textView.inputAccessoryView = nil
        }
        
        let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
        textView.addInteraction(dropInteraction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIMenuSystem.main.setNeedsRebuild()
        navigationItem.largeTitleDisplayMode = .never
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if shouldSave {
            saveNote()
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func toggleBoldface(_ sender: Any?) {
        textView.toggleBoldface(sender)
    }
    
    override func toggleItalics(_ sender: Any?) {
        textView.toggleItalics(sender)
    }
    
    override func toggleUnderline(_ sender: Any?) {
        textView.toggleUnderline(sender)
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
    
    ////Delete all resize handles
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
        updateExclusionPaths()
    }
    
    private func saveNote() {
        do {
            guard let note = note else {
                return
            }
            if textField.text?.replacingOccurrences(of: " ", with: "") != "" {
                note.title = textField.attributedText ?? NSAttributedString()
            }
            if textView.text?.replacingOccurrences(of: " ", with: "") != "" {
                note.text = textView.attributedText ?? NSAttributedString()
            }
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
    
    #if !targetEnvironment(macCatalyst)
    /// This method presents the image picker for accessing the camera
    internal func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = imagePickerDelegate
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true, completion: nil)
    }
    #endif
    
    /// This method adds a image box or a transcripted text from selected image in a text box to the current note
    internal func addMedia(from image: UIImage) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Image or text?".localized(),
                                          message: "Import the media as an image or as a text transcription (Beta version)".localized(),
                                          preferredStyle: .alert)
            
            let importImageAction = UIAlertAction(title: "Image".localized(), style: .default) { (_) in
                self.createImageBox(image: image)
            }
            
            let importTextAction = UIAlertAction(title: "Text".localized(), style: .default) { (_) in
                
                let textRecognition = TextRecognitionManager()
                let transcription = textRecognition.imageRequest(toImage: image)
                
                self.textView.insertText("\n\"\(transcription)\"\n")
            }
            
            alert.view.tintColor = .actionColor
            
            alert.addAction(importImageAction)
            alert.addAction(importTextAction)
            
            self.present(alert, animated: true, completion: nil)
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
    
    ///Adds a Text Box
    internal func addTextBox(with textBoxEntity: TextBoxEntity) {
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
        updateExclusionPaths()
    }
    
    ///Creates an Image Box
    internal func createImageBox(image: UIImage?) {
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
    internal func addImageBox(with imageBoxEntity: ImageBoxEntity) {
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
            updateExclusionPaths()
        }
    }
    
    ///Updates the position of the resize handles.
    internal func updateResizeHandles() {
        resizeHandles.forEach { (resizeHandle) in
            resizeHandle.updatePosition()
        }
    }
    
    ///Resizes the text view according to the keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = keyboardFrame.cgRectValue.height
            setTextViewConstant(to: -height)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        setTextViewConstant(to: 0)
    }
    private func setTextViewConstant(to value: CGFloat) {
        textViewBottomConstraint.constant = value
        UIView.animate(withDuration: 0.5) {
            self.textView.layoutIfNeeded()
        }
    }
    
    /**
     This method inserts a string into the text view.
     
     - Parameter text: The string that will be added to the text view.
     */
    internal func insertText(_ text: String) {
        self.textView.insertText("\n" + text + "\n")
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
    internal func createTextBox(transcription: String? = nil) {
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
                textBoxEntity.text = transcriptedText.toStyle(.paragraph)
            } else {
                textBoxEntity.text = "Text".localized().toStyle(.paragraph)
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
    
    /// This method presentes the photo picker for iOS and iPadOS
    internal func presentPhotoPicker() {
        #if !targetEnvironment(macCatalyst)
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = photoPickerDelegate
        
        self.present(picker, animated: true, completion: nil)
        #endif
    }
    
    /// This method presentes the camera picker for iOS and iPadOS
    internal func presentCameraPicker() {
        #if !targetEnvironment(macCatalyst)
        self.showImagePickerController(sourceType: .camera)
        #endif
    }
    
    // MARK: - Uptade exclusion path frames
    
    internal func updateExclusionPaths() {
        exclusionPaths.removeAll()
        
        imageBoxes.forEach { (imageBox) in
            let path = UIBezierPath(rect: imageBox.frame)
            exclusionPaths.append(path)
        }
        
        textBoxes.forEach { (textBox) in
            let path = UIBezierPath(rect: textBox.frame)
            exclusionPaths.append(path)
        }
        self.textView.textContainer.exclusionPaths = exclusionPaths
    }
    
    // MARK: - IBActions functions
    
    #if !targetEnvironment(macCatalyst)
    @IBAction private func toggleFormat(_ sender: UIKeyCommand) {
        textView.toggleFormat(sender)
    }
    #endif
    
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
                updateExclusionPaths()
            }
        }
    }
    
    @IBAction private func handleLongPressInImageBox(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard let boxView = gestureRecognizer.view as? ImageBoxView, let entity = boxView.entity else {
            return
        }
        
        if gestureRecognizer.state == .began {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .imageBox, deletionHandler: { [weak self] _ in
                let deleteAlertController = UIAlertController(title: "Delete Image Box confirmation".localized(),
                                                              message: "Warning".localized(),
                                                              preferredStyle: .alert).makeDeleteConfirmation(dataType: .imageBox, deletionHandler: {[weak self] _ in
                                                                do {
                                                                    boxView.removeFromSuperview()
                                                                    self?.imageBoxes.remove(boxView)
                                                                    self?.cleanResizeHandles()
                                                                    self?.updateExclusionPaths()
                                                                    try DataManager.shared().deleteImageBox(entity)
                                                                } catch {
                                                                    let alertController = UIAlertController(
                                                                        title: "Could not delete this Image Box".localized(),
                                                                        message: "The app could not delete the image box".localized(),
                                                                        preferredStyle: .alert)
                                                                        .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                    self?.present(alertController, animated: true, completion: nil)
                                                                }
                                                              })
                self?.present(deleteAlertController, animated: true, completion: nil)
            })
            alertController.popoverPresentationController?.sourceView = boxView
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func handleLongPressInTextBox(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard let boxView = gestureRecognizer.view as? TextBoxView, let entity = boxView.entity else {
            return
        }
        
        if gestureRecognizer.state == .began {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .textBox, deletionHandler: { [weak self] _ in
                let deleteAlertController = UIAlertController(title: "Delete Text Box confirmation".localized(),
                                                              message: "Warning".localized(),
                                                              preferredStyle: .alert).makeDeleteConfirmation(dataType: .textBox, deletionHandler: { [weak self] _ in
                                                                do {
                                                                    boxView.removeFromSuperview()
                                                                    self?.textBoxes.remove(boxView)
                                                                    self?.cleanResizeHandles()
                                                                    self?.updateExclusionPaths()
                                                                    try DataManager.shared().deleteTextBox(entity)
                                                                } catch {
                                                                    let alertController = UIAlertController(
                                                                        title: "Could not delete this Text Box".localized(),
                                                                        message: "The app could not delete the text box".localized(),
                                                                        preferredStyle: .alert)
                                                                        .makeErrorMessage(with: "An error occurred while deleting this instance on the database".localized())
                                                                    self?.present(alertController, animated: true, completion: nil)
                                                                }
                                                              })
                self?.present(deleteAlertController, animated: true, completion: nil)
            })
            
            alertController.popoverPresentationController?.sourceView = boxView
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    #if targetEnvironment(macCatalyst)
    @IBAction private func importImage() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPicker.delegate = documentPickerDelegate
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .automatic
        present(documentPicker, animated: true, completion: nil)
    }
    
    /**
     This method exports an PDF from Data and a title.
     - Parameter pdfData: The data to be writen into PDF.
     - Parameter title: The file title.
     */
    private func exportPDF(_ pdfData: Data, title: String) {
        let fileManager = FileManager.default
        
        do {
            let fileURL = fileManager.temporaryDirectory.appendingPathComponent("\(title).pdf")
            try pdfData.write(to: fileURL)
            
            let controller = UIDocumentPickerViewController(forExporting: [fileURL])
            present(controller, animated: true)
        } catch {
            let alertController = UIAlertController(
                title: "An error has occurred while exporting the PDF".localized(),
                message: "The app could not export the file as a PDF".localized(),
                preferredStyle: .alert)
                .makeErrorMessage(with: "Error writing data to the designed url".localized())
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction private func exportNote() {
        guard let note = note else {
            return
        }
        let pdfData = note.createDocument()
        
        var title = note.title.string
        if title.isEmpty {
            var lenght = 10
            if note.text.length < 10 {
                lenght = note.text.length
            }
            title = note.text.attributedSubstring(from: NSRange(location: 0, length: lenght)).string
        }
        
        exportPDF(pdfData, title: title)
    }
    
    @IBAction private func exportNotebook() {
        guard let notebook = notebook else {
            return
        }
        exportPDF(notebook.createFullDocument(), title: notebook.name)
    }
    #endif
}
