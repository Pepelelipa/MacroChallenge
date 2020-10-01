//
//  TextBoxView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira and Leonardo Amorim de Oliveira on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class TextBoxView: UIView, BoxView {
    
    var state: BoxViewState = .idle
    
    var internalFrame: CGRect = .zero
    
    private lazy var markupTextViewDelegate: MarkupTextViewDelegate? = {
        let delegate = MarkupTextViewDelegate()
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
                
                self.markupTextView.attributedText = attributedText
            }
            delegate.parsePlaceholder(on: self.markupTextView)
        }
        return delegate
    }()
    
    lazy var markupTextView: MarkupTextView = {
        let textView = MarkupTextView(frame: .zero)
        textView.delegate = markupTextViewDelegate
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
        
    var owner: MarkupTextView
        
    init(frame: CGRect, owner: MarkupTextView) {  
        self.owner = owner
        super.init(frame: frame)
        self.addSubview(markupTextView)
        self.markupTextView.font = UIFont(name: self.markupTextView.font?.fontName ?? "", size: 16)
        
        setUpTextViewConstraints()
        setUpLayer()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextViewConstraints() {
        NSLayoutConstraint.activate([
            markupTextView.topAnchor.constraint(equalTo: self.topAnchor),
            markupTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            markupTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            markupTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setUpLayer() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}
