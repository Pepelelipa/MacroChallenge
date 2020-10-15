//
//  MarkdownHeader+UIKit.swift
//  MarkdownKit
//
//  Created by Bruno Oliveira on 31/01/2019.
//  Copyright © 2019 Ivan Bruel. All rights reserved.
//

import UIKit

public extension MarkdownHeader {
    
    static let defaultFont = UIFont.openSans?.withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    
    static let firstHeaderFont: UIFont = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont.openSans?.withSize(26).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 26)
        case .pad:
            return UIFont.openSans?.withSize(32).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 32)
        default:
            return UIFont.boldSystemFont(ofSize: 26)
        }
    }()
    
    static let secondHeaderFont: UIFont = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont.openSans?.withSize(20).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 20)
        case .pad:
            return UIFont.openSans?.withSize(26).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 26)
        default:
            return UIFont.boldSystemFont(ofSize: 20)
        }
    }()
    
    static let thirdHeaderFont: UIFont = {
        let device = UIDevice.current.userInterfaceIdiom
        switch device {
        case .phone:
            return UIFont.openSans?.withSize(18).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 18)
        case .pad:
            return UIFont.openSans?.withSize(22).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 22)
        default:
            return UIFont.boldSystemFont(ofSize: 18)
        }
    }()
}
