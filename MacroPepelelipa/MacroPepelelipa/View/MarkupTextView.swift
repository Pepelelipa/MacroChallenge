//
//  MarkupTextView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class MarkupTextView: UITextView {
    
    init(frame: CGRect, delegate: MarkupTextViewDelegate) {
        super.init(frame: frame, textContainer: nil)
        self.delegate = delegate
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
