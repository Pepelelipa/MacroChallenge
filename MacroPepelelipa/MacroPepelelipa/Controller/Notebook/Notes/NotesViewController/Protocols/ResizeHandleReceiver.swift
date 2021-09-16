//
//  ResizeHandleReceiver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 09/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit
import MarkdownText

internal protocol ResizeHandleReceiver: AnyObject {
    var receiverView: UIView { get set }
    var textView: MarkdownTextView { get }
    func uptadeResizeHandles()
    func updateExclusionPaths()
}
