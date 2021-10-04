//
//  HeaderFont.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 29/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal extension UIFont {

    // MARK: Fonts
    static let openSans: UIFont? = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont(name: "OpenSans", size: 16)
        case .pad:
            return UIFont(name: "OpenSans", size: 21)
        default:
            return UIFont(name: "OpenSans", size: UIFont.labelFontSize + 1)
        }
    }()

    static let merriweather: UIFont? = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont(name: "Merriweather", size: 15)
        case .pad:
            return UIFont(name: "Merriweather", size: 20)
        default:
            return UIFont(name: "Merriweather", size: UIFont.labelFontSize)
        }
    }()

    static let dancingScript: UIFont? = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont(name: "Dancing Script", size: 18)
        case .pad:
            return UIFont(name: "Dancing Script", size: 23)
        default:
            return UIFont(name: "Dancing Script", size: UIFont.labelFontSize + 6)
        }
    }()

    static var defaultFont: UIFont {
        if let merriweather = merriweather {
            return merriweather
        } else {
            return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
    }
    static var defaultHeader: UIFont {
        if let openSans = openSans {
            return openSans
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            return systemFont(ofSize: 16)
        } else {
            return systemFont(ofSize: 21)
        }
    }
}
