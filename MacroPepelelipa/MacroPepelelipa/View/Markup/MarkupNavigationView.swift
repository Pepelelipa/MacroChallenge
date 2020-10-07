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
    
    init(frame: CGRect, configurations: MarkupBarConfiguration) {
        self.markupBarConfiguration = configurations
        super.init(frame: frame)
        
        setButtonConstraints()
        
        self.sizeToFit()
        self.tintColor = .toolsColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
    private func setButtonConstraints() {
        guard let barButtonItems = markupBarConfiguration?.setupUIButtons() else {
            return
        }
        
        NSLayoutConstraint.activate([
            barButtonItems[3].topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            barButtonItems[3].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            barButtonItems[3].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            barButtonItems[3].heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15)
        ])
        
        NSLayoutConstraint.activate([
            barButtonItems[2].topAnchor.constraint(equalTo: barButtonItems[3].topAnchor),
            barButtonItems[2].leadingAnchor.constraint(equalTo: barButtonItems[3].trailingAnchor, constant: 10),
            barButtonItems[2].bottomAnchor.constraint(equalTo: barButtonItems[3].bottomAnchor),
            barButtonItems[2].heightAnchor.constraint(equalTo: barButtonItems[3].heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            barButtonItems[0].topAnchor.constraint(equalTo: barButtonItems[3].topAnchor),
            barButtonItems[0].leadingAnchor.constraint(equalTo: barButtonItems[2].trailingAnchor, constant: 10),
            barButtonItems[0].bottomAnchor.constraint(equalTo: barButtonItems[3].bottomAnchor),
            barButtonItems[0].heightAnchor.constraint(equalTo: barButtonItems[3].heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            barButtonItems[4].topAnchor.constraint(equalTo: barButtonItems[3].topAnchor),
            barButtonItems[4].leadingAnchor.constraint(equalTo: barButtonItems[0].trailingAnchor, constant: 10),
            barButtonItems[4].bottomAnchor.constraint(equalTo: barButtonItems[3].bottomAnchor),
            barButtonItems[4].heightAnchor.constraint(equalTo: barButtonItems[3].heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            barButtonItems[1].topAnchor.constraint(equalTo: barButtonItems[3].topAnchor),
            barButtonItems[1].leadingAnchor.constraint(equalTo: barButtonItems[4].trailingAnchor, constant: 10),
            barButtonItems[1].bottomAnchor.constraint(equalTo: barButtonItems[3].bottomAnchor),
            barButtonItems[1].heightAnchor.constraint(equalTo: barButtonItems[3].heightAnchor)
        ])
    }
}
