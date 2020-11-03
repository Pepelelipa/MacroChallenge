//
//  TipViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class TipViewController: UIViewController {
    
    private(set) var tipTitle: MarkupTextField = {
        let textField = MarkupTextField(frame: .zero, placeholder: "Welcome Note".localized(), paddingSpace: 4)
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isEditing = false
        return textField
    }()
    
    private(set) lazy var tipBody: MarkupTextView = {
        let  markupTextView = MarkupTextView(frame: .zero, delegate: self.textViewDelegate)
        markupTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let parts: [NSAttributedString] = [
            "Onboard intro".localized().toNoteDefaulText(),
            "Workspaces".localized().toNoteH2Text(),
            "Workspace text".localized().toNoteDefaulText(),
            "Notebooks".localized().toNoteH2Text(),
            "Notebook text".localized().toNoteDefaulText(),
            "Note Taking".localized().toNoteH2Text(),
            "Writing".localized().toNoteH3Text(),
            "Writing text".localized().toNoteDefaulText(),
            "Floating Boxes".localized().toNoteH3Text(),
            "Floating boxes text".localized().toNoteDefaulText(),
            "Markdown".localized().toNoteH3Text(),
            "Markdown text".localized().toNoteDefaulText()
        ]
        
        let text = NSMutableAttributedString()
        for part in parts {
            text.append(part)
            text.append(NSAttributedString(string: "\n"))
            text.append(NSAttributedString(string: "\n"))
        }
        markupTextView.translatesAutoresizingMaskIntoConstraints = false
//        markupTextView.isUserInteractionEnabled = false
        markupTextView.attributedText = text
        return markupTextView
    }()
    
    internal lazy var textViewDelegate: MarkupTextViewDelegate = {
        let delegate = MarkupTextViewDelegate()
        return delegate
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = {
        [
            tipTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tipTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tipTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tipTitle.heightAnchor.constraint(equalToConstant: 30),
            
            tipBody.topAnchor.constraint(equalTo: self.tipTitle.bottomAnchor, constant: 20),
            tipBody.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipBody.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipBody.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tipTitle)
        view.addSubview(tipBody)
        
        self.view.backgroundColor = .backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLayoutConstraint.activate(constraints)
    }
    
}
