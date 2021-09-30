//
//  NotesView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 15/03/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText

internal class NotesView: UIView, MarkdownFormatViewReceiver {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    convenience required init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect else {
            return nil
        }
        self.init(frame: frame)
    }
    
    // MARK: - Private properties
    
    private let screenSize = UIScreen.main.bounds
    
    private lazy var markdownConfiguration: MarkdownBarConfiguration = {
        let configuration = MarkdownBarConfiguration(owner: self.textView)
        configuration.observer = self.configurationObserver
        return configuration
    }()
    
    private lazy var textFieldDelegate: MarkupTextFieldDelegate = {
        let delegate = MarkupTextFieldDelegate()
        delegate.observer = textEditingObserver
        return delegate
    }()
    
    // MARK: - Internal properties
    
    internal var markdownDelegate: AppMarkdownTextViewDelegate?
    internal weak var configurationObserver: MarkupToolBarObserver?
    internal weak var textEditingObserver: TextEditingDelegateObserver?
    
    internal private(set) lazy var textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)

    internal private(set) lazy var textField: MarkdownTextField = {
        let textField = MarkdownTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
        textField.delegate = self.textFieldDelegate
        textField.accessibilityLabel = "Note title".localized()
        textField.accessibilityHint = "Note title hint".localized()
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    internal private(set) lazy var textView: MarkdownTextView = {
        self.markdownDelegate = AppMarkdownTextViewDelegate()
        if let observer = textEditingObserver {
            self.markdownDelegate?.addTextObserver(observer)
        }
        
        let  markdownTextView = MarkdownTextView(frame: .zero)
        markdownTextView.markdownDelegate = markdownDelegate
        markdownTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 15, right: 20)
        markdownTextView.accessibilityLabel = "Note".localized()
        return markdownTextView
    }()
    
    internal private(set) lazy var markupContainerView: MarkdownContainerView = {
        let height: CGFloat = screenSize.height/4
        
        let container = MarkdownContainerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: height), owner: self.textView, receiver: self)
        
        container.autoresizingMask = []
        container.isHidden = true
        
        return container
    }()
    
    internal lazy var keyboardToolbar: MarkdownToolBar = {
        let toolBar = MarkdownToolBar(frame: .zero, configurations: markdownConfiguration)
        return toolBar
    }()
    
    internal lazy var notesToolbar: NotesToolbar = {
        let toolbar = NotesToolbar(frame: .zero)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    internal private(set) lazy var customConstraints: [NSLayoutConstraint] = {
        [
            textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            textViewBottomConstraint,
            
            notesToolbar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            notesToolbar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            notesToolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()
    
    // MARK: - Private methods

    private func addSubviews() {
        addSubview(textField)
        addSubview(textView)
        addSubview(markupContainerView)
        addSubview(notesToolbar)
    }
    
    // MARK: - Internal methods
    
    /**
     This method changes de main input view based on it being custom or not.
     - Parameter isCustom: A boolean indicating if the input view will be a custom view or not.
     */
    internal func changeTextViewInput(isCustom: Bool) {
        if isCustom == true {
            self.textView.inputView = self.markupContainerView
        } else {
            self.textView.inputView = nil
        }
        
        self.keyboardToolbar.isHidden.toggle()
        self.markupContainerView.isHidden.toggle()
        self.textView.reloadInputViews()
    }
}
