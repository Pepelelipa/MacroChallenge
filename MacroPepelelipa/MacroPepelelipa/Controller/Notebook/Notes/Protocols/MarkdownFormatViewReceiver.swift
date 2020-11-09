//
//  MarkdownFormatViewReceiver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 09/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import MarkdownText

internal protocol MarkdownFormatViewReceiver: class {
    func changeTextViewInput(isCustom: Bool)
    var delegate: AppMarkdownTextViewDelegate? { get set }
}
