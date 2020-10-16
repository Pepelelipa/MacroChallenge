//
//  UIIDeviceOrientation.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 16/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal extension UIDeviceOrientation {
    var isActuallyLandscape: Bool {
        let bounds = UIScreen.main.bounds
        if bounds.width > bounds.height {
            return true
        } else {
            return false
        }
    }
}
