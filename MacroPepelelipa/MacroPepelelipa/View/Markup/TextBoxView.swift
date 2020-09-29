//
//  TextBoxView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira and Leonardo Amorim de Oliveira on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class TextBoxView: UIView, TextBoxEditingDelegateObserver {
    
    private let markupTextViewDelegate = MarkupTextViewDelegate()
    
    private lazy var markupTextView: MarkupTextView = {
        let textView = MarkupTextView(frame: .zero) 
        textView.delegate = markupTextViewDelegate
        return textView
    }()
    
    var canEdit: Bool = false
    
    override init(frame: CGRect) {  
        super.init(frame: frame)
        
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing() {
        
        DispatchQueue.main.async {
            self.canEdit = false
            self.backgroundColor = .red
        }
    }
}
