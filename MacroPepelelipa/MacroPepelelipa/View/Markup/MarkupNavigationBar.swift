//
//  MarkupNavigationBar.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 06/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupNavigationBar: UINavigationBar {
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
        
//        setUpButtons()
        navigationItem?.titleView = MarkupToolBar(frame: .infinite, configurations: configurations)
        
        self.sizeToFit()
        self.tintColor = .toolsColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     A private method to set up all the Buttons on the UIToolBar.
     */
//    public func setUpButtons() {
//
//        guard let barButtonItems = markupBarConfiguration?.setUpButtons() else {
//            return
//        }
//
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let button = UIButton(frame: .zero)
//
//        navigationItem?.titleView = button
//
//        navigationItem?.backBarButtonItem = flexible
//
//
//
//        self.items = [flexible, barButtonItems[3], flexible, barButtonItems[2]]
//        for _ in 0...9 {
////            navigationItem?.titleView = flexible
//            self.items?.append(flexible)
//        }
//
//        self.items?.append(barButtonItems[4])
//        self.items?.append(flexible)
//
//        self.items?.append(barButtonItems[0])
//        self.items?.append(flexible)
//
//        MarkupToolBar.paragraphButton = barButtonItems[1]
//
//        if let paragraphBtn = MarkupToolBar.paragraphButton {
//            self.items?.append(paragraphBtn)
//            self.items?.append(flexible)
//        }
//    }
}
