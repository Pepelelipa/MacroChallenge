//
//  MarkupViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupViewController: UIViewController {
    
    private var boldButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "bold", style: .plain, target: self, action: #selector(pressBoldButton))
        return barButtonItem
    }()
    
    private lazy var keyboardToolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.items = [boldButton]
        return toolBar
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
        
        imageView = UIImageView(image: UIImage(systemName: "ant.fill"))
        textView.addSubview(imageView)
        
        textView.inputAccessoryView = keyboardToolbar
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            textView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
        
        imageView.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        
        let exclusionPath = UIBezierPath(rect: imageView.frame)
        textView.textContainer.exclusionPaths = [exclusionPath]
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
