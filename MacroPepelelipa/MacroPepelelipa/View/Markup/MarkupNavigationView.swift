//
//  MarkupNavigationBar.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupNavigationView: UIStackView {
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
        
        setButtonConstraints()
        
        self.sizeToFit()
        self.tintColor = UIColor.toolsColor

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set up all the buttons on the navigation bar.
     */
    private func setButtonConstraints() {
        guard let barButtonItems = markupBarConfiguration?.setupUIButtons() else {
            return
        }
        
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = 5.0
        
        self.addArrangedSubview(barButtonItems[3])
        self.addArrangedSubview(barButtonItems[2])
        self.addArrangedSubview(barButtonItems[0])
        self.addArrangedSubview(barButtonItems[4])
        self.addArrangedSubview(barButtonItems[1])
    }
}
