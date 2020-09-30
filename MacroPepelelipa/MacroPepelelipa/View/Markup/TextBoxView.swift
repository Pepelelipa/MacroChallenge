//
//  TextBoxView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira and Leonardo Amorim de Oliveira on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class TextBoxView: UIView {
        
    private lazy var markupTextViewDelegate: MarkupTextViewDelegate = {
        let delegate = MarkupTextViewDelegate()
        return delegate
    }()
    
    private lazy var markupTextView: MarkupTextView = {
        let textView = MarkupTextView(frame: .zero)
        textView.delegate = markupTextViewDelegate
        return textView
    }()
    
    var canEdit: Bool = false
    var owner: MarkupTextView
    
    init(frame: CGRect, owner: MarkupTextView) {  
        self.owner = owner
        super.init(frame: frame)
        self.addSubview(markupTextView)
        
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
