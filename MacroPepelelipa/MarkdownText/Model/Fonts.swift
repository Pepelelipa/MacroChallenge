//
//  Fonts.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public enum FontStyle: Int {
    case h1 = 1
    case h2 = 2
    case h3 = 3
    case paragraph = 4
}

public struct Fonts {
    private init() {}
    public static var availableFonts: [UIFont] = []
    public static var defaultTextFont: UIFont = UIFont()
}
