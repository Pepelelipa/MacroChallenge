//
//  BoxView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 01/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

enum BoxViewState {
    case idle
    case editing
}

protocol BoxView: UIView {
    var state: BoxViewState { get set }
    var internalFrame: CGRect { get set }
    var owner: MarkupTextView { get set }
}
