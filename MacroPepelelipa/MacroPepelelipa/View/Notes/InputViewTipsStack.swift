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
    
    private let stackType: InputViewType
    private var tipImageView = UIImageView()
    private var tipLabel = UILabel()
    
    init(of type: InputViewType) {
        self.stackType = type
        
        super.init(frame: .zero)
        
        buildInputStackView()
        
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fillProportionally
        self.spacing = 4
    }
    
    internal func buildInputStackView() {
        switch stackType {
        case .bold:
            let attributedText = NSMutableAttributedString(attributedString: "Bold".localized().toStyle(.bold))
            
            tipLabel.attributedText = attributedText
            tipImageView.image = UIImage(named: "Bold Tip")
            
            self.addArrangedSubview(tipImageView)
            self.addArrangedSubview(tipLabel)            
        case .highlighted:
            let attributedText = NSMutableAttributedString(attributedString: "Highlighted".localized().toStyle(.paragraph))
            attributedText.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.highlightColor ?? .systemYellow], range: NSRange(location: 0, length: attributedText.length))
            
            tipLabel.attributedText = attributedText
            tipImageView.image = UIImage(named: "Highlighted Tip")
            
            self.addArrangedSubview(tipImageView)
            self.addArrangedSubview(tipLabel)            
        case .italic:
            let attributedText = NSMutableAttributedString(attributedString: "Italic".localized().toStyle(.italic))
            
            tipLabel.attributedText = attributedText
            tipImageView.image = UIImage(named: "Italic Tip")
            
            self.addArrangedSubview(tipImageView)
            self.addArrangedSubview(tipLabel)            
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

internal enum InputViewType {
    case highlighted
    case bold
    case italic
}
