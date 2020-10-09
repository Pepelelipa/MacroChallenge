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
    
    static let firstHeaderFont = UIFont.openSans?.withSize(23).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 22)
    
    static let secondHeaderFont = UIFont.openSans?.withSize(22).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 20)
    
    static let thirdHeaderFont = UIFont.openSans?.withSize(18).withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 17)
}
