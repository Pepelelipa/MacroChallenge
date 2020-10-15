//
//  MarkupNavigationBar.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupNavigationView: UIView {
    private weak var markupBarConfiguration: MarkupBarConfiguration?
    
    private static var paragraphButton: UIBarButtonItem?
    private var navigationItem: UINavigationItem?
    
    public static var headerStyle: HeaderStyle = .h1 {
        didSet {
            if MarkupToolBar.headerStyle == .h1 {
                paragraphButton?.image = UIImage(named: "h1")
            }
        }
    }
    
    public lazy var barButtonItems: [UIButton] = {
        guard let buttons = markupBarConfiguration?.setupUIButtons() else {
            return [UIButton]()
        }
        
        return buttons
    }()
    
    init(frame: CGRect, configurations: MarkupBarConfiguration) {
        self.markupBarConfiguration = configurations
        super.init(frame: frame)
        
        barButtonItems.forEach({
            self.addSubview($0)
        })
        
        setConstraints()
        
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set the buttons constraints.
     */
    private func setConstraints() {
        barButtonItems.forEach({
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                $0.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
                $0.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
            ])
        })
        
        NSLayoutConstraint.activate([
            barButtonItems[3].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            barButtonItems[2].leadingAnchor.constraint(equalTo: barButtonItems[3].trailingAnchor, constant: 10),
            barButtonItems[4].leadingAnchor.constraint(equalTo: barButtonItems[2].trailingAnchor, constant: 10),
            barButtonItems[0].leadingAnchor.constraint(equalTo: barButtonItems[4].trailingAnchor, constant: 10),
            barButtonItems[1].leadingAnchor.constraint(equalTo: barButtonItems[0].trailingAnchor, constant: 10)
        ])
    }
}
