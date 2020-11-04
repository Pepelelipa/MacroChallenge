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
    
    private var navigationItem: UINavigationItem?
    private weak var markupBarConfiguration: MarkdownBarConfiguration?
    private static var paragraphButton: UIBarButtonItem?
    
    internal lazy var barButtonItems: [UIButton] = {
        guard let buttons = markupBarConfiguration?.setupUIButtons() else {
            return [UIButton]()
        }
        
        return buttons
    }()
    
    // MARK: - Initializers
    
    internal init(frame: CGRect, configurations: MarkdownBarConfiguration) {
        self.markupBarConfiguration = configurations
        super.init(frame: frame)
        
        barButtonItems.forEach({
            self.addSubview($0)
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
        barButtonItems.forEach({
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        })
        
        NSLayoutConstraint.activate([
            barButtonItems[3].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            barButtonItems[2].leadingAnchor.constraint(equalTo: barButtonItems[3].trailingAnchor, constant: 10),
            barButtonItems[4].leadingAnchor.constraint(equalTo: barButtonItems[2].trailingAnchor, constant: 10),
            barButtonItems[0].leadingAnchor.constraint(equalTo: barButtonItems[4].trailingAnchor, constant: 10),
            barButtonItems[1].leadingAnchor.constraint(equalTo: barButtonItems[0].trailingAnchor, constant: 10),
            barButtonItems[1].trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
