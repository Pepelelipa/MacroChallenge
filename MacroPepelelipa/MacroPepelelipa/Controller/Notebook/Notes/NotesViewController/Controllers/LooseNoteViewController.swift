//
//  LooseNoteViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 11/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import PhotosUI
import MarkdownText

internal class LooseNoteViewController: UIViewController, 
                                    TextEditingDelegateObserver,
                                    MarkupToolBarObserver,
                                    MarkdownFormatViewReceiver,
                                    ResizeHandleReceiver,
                                    BoxViewReceiver,
                                    NoteAssignerObserver {
    
    // MARK: - Variables and Constants
        
    private var resizeHandles = [ResizeHandleView]()
    private var initialCenter = CGPoint()
    private var exclusionPaths: [UIBezierPath] = []
    private var workspaces: () -> [WorkspaceEntity]
    
    private let screenSize = UIScreen.main.bounds
    
    internal var textBoxes: Set<TextBoxView> = []
    internal var imageBoxes: Set<ImageBoxView> = []
    internal lazy var receiverView: UIView = self.view

    internal var note: NoteEntity?
    internal var delegate: AppMarkdownTextViewDelegate?
    internal private(set) weak var notebook: NotebookEntity?
    
    private lazy var resizeHandleFunctions = ResizeHandleFunctions(owner: self)
    private lazy var boxViewInteractions = BoxViewInteractions(resizeHandleReceiver: self, boxViewReceiver: self, center: Float(self.view.frame.width/2))
    private lazy var noteContentHandler = NoteContentHandler()
    private lazy var notesControllerConfiguration = NotesViewControllerConfiguration(boxViewReceiver: self)
    
    private lazy var textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    
    private lazy var textField: MarkdownTextField = {
        let textField = MarkdownTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
        textField.delegate = self.textFieldDelegate
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
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textViewBottomConstraint
        ]
    }()
    
    private lazy var btnAddLooseNote = UIBarButtonItem(title: "Finish".localized(), style: .plain, target: self, action: #selector(addToNotebook))
    
    private lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(ofType: .done,
                                   target: self,
                                   action: #selector(closeKeyboard))
        item.tintColor = UIColor.actionColor
        return item
    }()
    
    internal private(set) lazy var textView: MarkdownTextView = {
        let  markdownTextView = MarkdownTextView(frame: .zero)
        self.delegate = AppMarkdownTextViewDelegate()
        delegate?.addTextObserver(self)
        markdownTextView.markdownDelegate = delegate
        markdownTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        markdownTextView.placeholder = "Placeholder\(Int.random(in: 0...15))".localized()
        return markdownTextView
    }()
    
    internal lazy var markupConfig: MarkdownBarConfiguration = {
        let mrkConf = MarkdownBarConfiguration(owner: textView)
        mrkConf.observer = self
        return mrkConf
    }()
    
    internal private(set) lazy var markupContainerView: MarkdownContainerView = {
        let height: CGFloat = screenSize.height/4
        
        let container = MarkdownContainerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: height), owner: self.textView, receiver: self)
        
        container.autoresizingMask = []
        container.isHidden = true
        
        return container
    }()
    
    private lazy var boldfaceKeyCommand: UIKeyCommand = {
        let command = UIKeyCommand(input: "B", modifierFlags: .command, action: #selector(textView.toggleFormat(_:)))
        command.discoverabilityTitle = "Bold".localized()
        return command
    }()
    
    private lazy var italicsKeyCommand: UIKeyCommand = {
        let command = UIKeyCommand(input: "I", modifierFlags: .command, action: #selector(textView.toggleFormat(_:)))
        command.discoverabilityTitle = "Italic".localized()
        return command
    }()
    
    private lazy var underlineKeyCommand: UIKeyCommand = {
        let command = UIKeyCommand(input: "U", modifierFlags: .command, action: #selector(textView.toggleFormat(_:)))
        command.discoverabilityTitle = "Underline".localized()
        return command
    }()
    
    private lazy var dropInteractionDelegate: DropInteractionDelegate = DropInteractionDelegate(viewController: self)
        
    #if !targetEnvironment(macCatalyst)
    internal lazy var photoPickerDelegate = PhotoPickerDelegate { (image, error) in
        if let error = error {
            let title = "Error presenting Photo Library".localized()
            let message = "The app could not load the native Image Picker Controller".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
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
    #else
    private lazy var documentPickerDelegate: DocumentPickerDelegate = {
        return DocumentPickerDelegate { image in
            self.addMedia(from: image)
        }
    }()
    #endif
    
    // MARK: - Initializers
    
    internal init(note: NoteEntity, notebook: NotebookEntity? = nil, workspaces: @escaping () -> [WorkspaceEntity]) {
        self.note = note
        self.notebook = notebook
        self.workspaces = workspaces
        super.init(nibName: nil, bundle: nil)
    }

    internal required convenience init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity,
              let workspaces = coder.decodeObject(forKey: "workspaces") as? () -> [WorkspaceEntity]
              else {
            return nil
        }
        self.init(note: note, notebook: coder.decodeObject(forKey: "notebook") as? NotebookEntity, workspaces: workspaces)
    }

    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyCommand(boldfaceKeyCommand)
        addKeyCommand(italicsKeyCommand)
        addKeyCommand(underlineKeyCommand)

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
        
        notesControllerConfiguration.configureNotesViewControllerContent(textView: textView, textField: textField, note: note, keyboardToolbar: keyboardToolbar)
        
        updateExclusionPaths()
                
        let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
        textView.addInteraction(dropInteraction)
        
        navigationItem.rightBarButtonItems = [btnAddLooseNote]
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor.actionColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        NSLayoutConstraint.activate(constraints)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // MARK: - Functions
    
    #if !targetEnvironment(macCatalyst)
    /// This method presents the image picker for accessing the camera
    internal func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = imagePickerDelegate
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
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
    #endif
    
    #if targetEnvironment(macCatalyst)
    @IBAction private func importImagFromFinder() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPicker.delegate = documentPickerDelegate
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .automatic
        present(documentPicker, animated: true, completion: nil)
    }
    
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
    #endif
    
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
            textBox.markupTextView.setText(textBoxEntity.text.replaceColors())
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
        guard let note = note else {
            let title = "Note does not exist".localized()
            let message = "Failed to load the Note".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            return
        }
        boxViewInteractions.createImageBox(image: image, note: note)
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
        if navigationItem.rightBarButtonItems?.firstIndex(of: doneButton) == nil {
            navigationItem.rightBarButtonItems?.append(doneButton)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        setTextViewConstant(to: 0)
        if let index = navigationItem.rightBarButtonItems?.firstIndex(of: doneButton) {
            navigationItem.rightBarButtonItems?.remove(at: index)
        }
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
            
            if !self.resizeHandles.isEmpty {
                self.resizeHandles.forEach { (resizeHandle) in
                    resizeHandle.removeFromSuperview()
                }
            }
        }
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
        guard let note = note else {
            let title = "Note does not exist".localized()
            let message = "Failed to load the Note".localized()
            
            ConflictHandlerObject().genericErrorHandling(title: title, message: message)
            return
        }
        boxViewInteractions.createTextBox(transcription: transcription, note: note)
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

    #if targetEnvironment(macCatalyst)
    internal func importImage() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPicker.delegate = documentPickerDelegate
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .automatic
        present(documentPicker, animated: true, completion: nil)
    }
    #endif
    
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
    
    // MARK: - NoteAssignerObserver Method
    func dismissLooseNoteViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBActions functions
    
    // This method is called 
    /// This method stops editing the view
    
    @IBAction private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func didTap() {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    
    @IBAction func addToNotebook() {
        let destination = NoteAssignerViewController(note: note, lastNotebook: notebook, workspaces: workspaces)
        destination.observer = self
        noteContentHandler.saveNote(note: &note, textField: textField, textView: textView, textBoxes: textBoxes, imageBoxes: imageBoxes)
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if let boxView = gestureRecognizer.view as? BoxView {
            boxView.state = .editing
            resizeHandleFunctions.placeResizeHandles(boxView: boxView, resizeHandles: &resizeHandles)
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
                boxViewInteractions.moveBoxView(boxView: boxView, by: newCenter)
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
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .imageBox, deletionHandler: { _ in
                let deleteAlertController = UIAlertController(title: "Delete Image Box confirmation".localized(),
                                                              message: "Warning".localized(),
                                                              preferredStyle: .alert).makeDeleteConfirmation(dataType: .imageBox, deletionHandler: { _ in
                                                                do {
                                                                    boxView.removeFromSuperview()
                                                                    self.imageBoxes.remove(boxView)
                                                                    self.resizeHandleFunctions.cleanResizeHandles(resizeHandles: &self.resizeHandles)
                                                                    self.updateExclusionPaths()
                                                                    try DataManager.shared().deleteImageBox(entity)
                                                                } catch {
                                                                    let title = "Could not delete this Image Box".localized()
                                                                    let message = "An error occurred while deleting this instance on the database".localized()
                                                                    
                                                                    ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                                                                }
                                                              })
                self.present(deleteAlertController, animated: true, completion: nil)
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
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).makeDeleteConfirmation(dataType: .textBox, deletionHandler: { _ in
                let deleteAlertController = UIAlertController(title: "Delete Text Box confirmation".localized(),
                                                              message: "Warning".localized(),
                                                              preferredStyle: .alert).makeDeleteConfirmation(dataType: .textBox, deletionHandler: { _ in
                                                                do {
                                                                    boxView.removeFromSuperview()
                                                                    self.textBoxes.remove(boxView)
                                                                    self.resizeHandleFunctions.cleanResizeHandles(resizeHandles: &self.resizeHandles)
                                                                    self.updateExclusionPaths()
                                                                    try DataManager.shared().deleteTextBox(entity)
                                                                } catch {
                                                                    let title = "Could not delete this Text Box".localized()
                                                                    let message = "The app could not delete the text box".localized()
                                                                    
                                                                    ConflictHandlerObject().genericErrorHandling(title: title, message: message)
                                                                }
                                                              })
                self.present(deleteAlertController, animated: true, completion: nil)
            })

            alertController.popoverPresentationController?.sourceView = boxView
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
