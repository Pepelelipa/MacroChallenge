//
//  InputViewTipsStack.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 05/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class InputViewTipsStack: UIStackView {
    
    private let stackType: InputViewType?
    private var tipImageView = UIImageView()
    private var tipLabel = UILabel()
    
    internal init(of type: InputViewType? = nil) {
        self.stackType = type
        
        super.init(frame: .zero)
        
        buildInputStackView()
        
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fillProportionally
        self.spacing = 4
    }
    
    internal func buildInputStackView() {
        guard let boldFont = UIFont.defaultFont.bold(),
              let italicFont = UIFont.defaultFont.italic() else {
            return
        }
        switch stackType {
        case .bold:
            let attributedText = NSMutableAttributedString(attributedString: "Bold".localized().toFontWithColor(font: boldFont))
            
            tipLabel.attributedText = attributedText
            tipImageView.image = UIImage(named: "Bold Tip")
            
            self.addArrangedSubview(tipImageView)
            self.addArrangedSubview(tipLabel)            
        case .highlighted:
            let attributedText = NSMutableAttributedString(attributedString: "Highlighted".localized().toFontWithColor(font: italicFont))
            attributedText.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.highlightColor ?? .systemYellow], range: NSRange(location: 0, length: attributedText.length))
            
            tipLabel.attributedText = attributedText
            tipImageView.image = UIImage(named: "Highlighted Tip")
            
            self.addArrangedSubview(tipImageView)
            self.addArrangedSubview(tipLabel)            
        case .italic:
            let attributedText = NSMutableAttributedString(attributedString: "Italic".localized().toStyle(font: italicFont, .paragraph))
            
            tipLabel.attributedText = attributedText
            tipImageView.image = UIImage(named: "Italic Tip")
            
            self.addArrangedSubview(tipImageView)
            self.addArrangedSubview(tipLabel)            
        case .none:
            break
        }
    }
    
    internal required convenience init(coder: NSCoder) {
        if let type = coder.decodeObject(forKey: "type") as? InputViewType {
            self.init(of: type)
        } else {
            self.init()
        }
    }
}

internal enum InputViewType {
    case highlighted
    case bold
    case italic
}
