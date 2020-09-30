//
//  ColorExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public extension UIColor {
    static let actionColor = UIColor(named: "Action")
    static let backgroundColor = UIColor(named: "Background")
    static let bodyColor = UIColor(named: "Body")
    static let placeholderColor = UIColor(named: "Placeholder")
    static let rootColor = UIColor(named: "Root")
    static let titleColor = UIColor(named: "Title")
    static let toolsColor = UIColor(named: "Tools")
    #if DEBUG
    ///Generates a random UIColor
    static func random() -> UIColor {
    return UIColor(
    red: .random(in: 0.4...1),
    green: .random(in: 0.4...1),
    blue: .random(in: 0.4...1),
    alpha: 1)
    }
    #endif
}

#if DEBUG
import CoreGraphics
public extension CGColor {
    ///Generates a random CGColor
    static func random() -> CGColor {
        return CGColor(
            red: .random(in: 0.4...1),
            green: .random(in: 0.4...1),
            blue: .random(in: 0.4...1),
            alpha: 1)
    }
}
#endif
