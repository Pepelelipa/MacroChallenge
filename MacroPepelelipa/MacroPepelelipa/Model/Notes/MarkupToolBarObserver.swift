//
//  AddingBoxViewDelegateObserver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal protocol MarkupToolBarObserver: class {
    func addTextBox(with frame: CGRect, transcription: String?)
    func presentPicker()
    func changeTextViewInput(isCustom: Bool)
    func openPopOver()
}
