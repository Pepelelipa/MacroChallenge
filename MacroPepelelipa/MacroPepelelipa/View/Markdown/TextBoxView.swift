//
//  TextBoxView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira and Leonardo Amorim de Oliveira on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database
import MarkdownText

internal class TextBoxView: UIView, BoxView {
    
    // MARK: - Variables and Constants
    
    internal var owner: MarkdownTextView
    internal var internalFrame: CGRect = .zero
    internal var boxViewBorder = CAShapeLayer()
    internal weak var entity: TextBoxEntity?
    
    internal var state: BoxViewState {
        didSet {
            switch state {
            case .idle:
                boxViewBorder.isHidden = true
            case .editing:
                boxViewBorder.isHidden = false
            }
        }
    }
    
    internal lazy var markupTextView: MarkdownTextView = {
        let textView = MarkdownTextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    // MARK: - Initializers
                
    internal init(textBoxEntity: TextBoxEntity, owner: MarkdownTextView) {
        self.owner = owner
        self.state = .idle

        let frame = CGRect(
            x: CGFloat(textBoxEntity.x),
            y: CGFloat(textBoxEntity.y),
            width: CGFloat(textBoxEntity.width),
            height: CGFloat(textBoxEntity.height))
        self.entity = textBoxEntity

        super.init(frame: frame)
        
        markupTextView.setText(textBoxEntity.text.replaceColors())
        self.addSubview(markupTextView)
        self.markupTextView.font = UIFont(name: self.markupTextView.font?.fontName ?? "", size: 16)
        
        setUpTextViewConstraints()
        setUpBorder()   
        self.layer.addSublayer(boxViewBorder)
        boxViewBorder.isHidden = true
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let textBoxEntity = coder.decodeObject(forKey: "textBoxEntity") as? TextBoxEntity,
              let owner = coder.decodeObject(forKey: "owner") as? MarkdownTextView else {
            return nil
        }

        self.init(textBoxEntity: textBoxEntity, owner: owner)
    }
    
    // MARK: - Functions
    
    private func setUpTextViewConstraints() {
        NSLayoutConstraint.activate([
            markupTextView.topAnchor.constraint(equalTo: self.topAnchor),
            markupTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            markupTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            markupTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /**
     Draw the text box border.
     */
    internal func setUpBorder() {
        boxViewBorder.strokeColor = UIColor.actionColor?.cgColor
        boxViewBorder.lineDashPattern = [2, 2]
        boxViewBorder.frame = self.bounds
        boxViewBorder.fillColor = nil
        boxViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
    }
    
}
