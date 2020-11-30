//
//  MarkupNavigationBar.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkdownNavigationView: UIView {
    
    // MARK: - Variables and Constants
    
    private weak var markupBarConfiguration: MarkdownBarConfiguration?
    private static var paragraphButton: UIBarButtonItem?
    
    internal lazy var barButtonItems: [BarButtonType: UIButton] = {
        guard let buttons = markupBarConfiguration?.setupUIButtons() else {
            return [BarButtonType: UIButton]()
        }
        
        return buttons
    }()
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, configurations: MarkdownBarConfiguration) {
        self.markupBarConfiguration = configurations
        super.init(frame: frame)
        
        barButtonItems.forEach({
            self.addSubview($0.value)
        })
        
        setConstraints()
        
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor
        self.backgroundColor = .clear
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let frame = coder.decodeObject(forKey: "frame") as? CGRect,
              let configuration = coder.decodeObject(forKey: "configurations") as? MarkdownBarConfiguration else {
            return nil
        }
        self.init(frame: frame, configurations: configuration)
    }
    
    // MARK: - Functions
    
    ///A private method to set the buttons constraints.
    private func setConstraints() {
        for (_, button) in barButtonItems {
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: self.topAnchor),
                button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        guard let textBox = barButtonItems[.textBox],
              let image = barButtonItems[.image],
              let format = barButtonItems[.format],
              let list = barButtonItems[.list],
              let paragraph = barButtonItems[.paragraph] else {
            return
        }
        
        NSLayoutConstraint.activate([
            textBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: textBox.trailingAnchor, constant: 10),
            format.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            list.leadingAnchor.constraint(equalTo: format.trailingAnchor, constant: 10),
            paragraph.leadingAnchor.constraint(equalTo: list.trailingAnchor, constant: 10),
            paragraph.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
