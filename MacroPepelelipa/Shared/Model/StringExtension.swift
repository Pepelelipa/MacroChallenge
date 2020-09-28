//
//  StringExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
}
