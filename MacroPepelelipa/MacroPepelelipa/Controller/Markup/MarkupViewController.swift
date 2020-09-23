//
//  MarkupViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupViewController: UIViewController {
    
    private var textField: MarkupTextField = {
        return MarkupTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
    }()
    
    private lazy var keyboardToolbar: MarkupToolBar = {
        return MarkupToolBar(frame: .zero, owner: textView)
    }()
    
    private lazy var textView: MarkupTextView = {
        return MarkupTextView(
            frame: .zero,
            delegate: self.textViewDelegate ?? MarkupTextViewDelegate()
        )
    }()
    
    var imageView: UIImageView!
    
    private var textViewDelegate: MarkupTextViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        setUpTextField()
        self.view.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
        
        imageView = UIImageView(image: UIImage(systemName: "ant.fill"))
        textView.addSubview(imageView)
        
        textView.inputAccessoryView = keyboardToolbar
    }
    
    override func viewDidLayoutSubviews() {
        
        setUpTextFieldConstraints()
        setUpTextViewConstraints()
        
        imageView.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        
        let exclusionPath = UIBezierPath(rect: imageView.frame)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
            
    private func setUpTextField() {
        self.view.addSubview(textField)
    }
    
    private func setUpTextView() {
        textViewDelegate = MarkupTextViewDelegate()
        textViewDelegate?.markdownAttributesChanged = { [weak self](attributtedString, error) in
            if let error = error {
                NSLog("Error requesting -> \(error)")
                return
            }
          
            guard let attributedText = attributtedString else {
                NSLog("No error nor string found")
                return
            }
          
            self?.textView.attributedText = attributedText
        }
        self.view.addSubview(textView)
        self.textViewDelegate?.parsePlaceholder(on: self.textView)
    }
    
    private func setUpTextViewConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpTextFieldConstraints() {
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    /**
    In this funcion, we deal with the toolbar button for bold text, adding bold manually.
    */
    @objc func pressBoldButton() {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let boldFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        
        let range = textView.selectedRange
        
        let attribute = [NSAttributedString.Key.font: boldFont]
            
        attributedString.addAttributes(attribute, range: range)
        
        textView.attributedText = attributedString
    }

}
