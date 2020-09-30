//
//  ColorExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if DEBUG
import UIKit
public extension UIColor {
    ///Generates a random UIColor
    static func random() -> UIColor {
    return UIColor(
    red: .random(in: 0.4...1),
    green: .random(in: 0.4...1),
    blue: .random(in: 0.4...1),
    alpha: 1)
    }
}

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
