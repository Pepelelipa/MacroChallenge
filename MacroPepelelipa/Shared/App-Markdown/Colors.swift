//
//  Colors.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 30/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal extension UIColor {
    #if DEBUG
    ///Generates a random UIColor
    static func random(alpha: CGFloat = 1) -> UIColor {
        return UIColor(
            red: .random(in: 0.4...1),
            green: .random(in: 0.4...1),
            blue: .random(in: 0.4...1),
            alpha: alpha)
    }
    #endif

    ///Gets all the notebooks colors
    static var notebookColors: [UIColor] = {
        var colors: [UIColor] = []
        for i in 0...23 {
            if let color = UIColor(named: "nb\(i)") {
                colors.append(color)
            }
        }
        return colors
    }()

    ///Generates a random notebook color
    static func randomNotebookColor(alpha: CGFloat = 1) -> UIColor? {
        guard let color = notebookColors.randomElement() else {
            return nil
        }
        return color.withAlphaComponent(alpha)
    }

    ///Gets the name of an UIColor
    static func notebookColorName(of color: UIColor) -> String? {
        if let index = notebookColors.firstIndex(of: color) {
            return "nb\(index)"
        }
        
        if let baseColor = color.value(forKey: "baseColor") as? UIColor,
           let index = notebookColors.firstIndex(of: baseColor) {
            return "nb\(index)"
        }
        
        return nil
    }

    static var actionColor: UIColor? = {
        UIColor(named: "Action")
    }()
    static var backgroundColor: UIColor? = {
        UIColor(named: "Background")
    }()
    static var bodyColor: UIColor? = {
        UIColor(named: "Body")
    }()
    static var placeholderColor: UIColor? = {
        UIColor(named: "Placeholder")
    }()
    static var rootColor: UIColor? = {
        UIColor(named: "Root")
    }()
    static var titleColor: UIColor? = {
        UIColor(named: "Title")
    }()
    static var toolsColor: UIColor? = {
        UIColor(named: "Tools")
    }()
    static var formatColor: UIColor? = {
        UIColor(named: "Format")
    }()
    static let highlightColor: UIColor? = {
        UIColor(named: "Highlight")
    }()
}
