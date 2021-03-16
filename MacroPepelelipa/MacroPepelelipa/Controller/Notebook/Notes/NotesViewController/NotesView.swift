//
//  NotesView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 15/03/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText

class NotesView: UIView {
    
    internal weak var formatViewReceiver: MarkdownFormatViewReceiver?
    
    private let screenSize = UIScreen.main.bounds

    internal private(set) lazy var textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)

    internal private(set) lazy var textField: MarkdownTextField = {
        let textField = MarkdownTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
//        textField.delegate = self.textFieldDelegate
        textField.accessibilityLabel = "Note title".localized()
        textField.accessibilityHint = "Note title hint".localized()
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    internal private(set) lazy var textView: MarkdownTextView = {
        let  markdownTextView = MarkdownTextView(frame: .zero)
//        self.delegate = AppMarkdownTextViewDelegate()
//        delegate?.addTextObserver(self)
//        markdownTextView.markdownDelegate = delegate
        markdownTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        markdownTextView.placeholder = "Placeholder\(Int.random(in: 0...15))".localized()
        markdownTextView.accessibilityLabel = "Note".localized()
        return markdownTextView
    }()
    
//    internal private(set) lazy var markupContainerView: MarkdownContainerView = {
//        let height: CGFloat = screenSize.height/4
//        
//        let container = MarkdownContainerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: height), owner: self.textView, receiver: formatViewReceiver)
//        
//        container.autoresizingMask = []
//        container.isHidden = true
//        
//        return container
//    }()
//    
//    private lazy var keyboardToolbar: MarkdownToolBar = {
//        let toolBar = MarkdownToolBar(frame: .zero, configurations: markupConfig)
//        return toolBar
//    }()
    
    internal private(set) lazy var customConstraints: [NSLayoutConstraint] = {
        [
            textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            textViewBottomConstraint
        ]
    }()
    
    private func addSubviews() {
        addSubview(textField)
        addSubview(textView)
//        addSubview(markupContainerView)
    }
    
}
