//
//  BoxViewReceiver.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 10/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Database

internal protocol BoxViewReceiver: class {
    func addTextBox(with textBoxEntity: TextBoxEntity)
    func addImageBox(with imageBoxEntity: ImageBoxEntity)
}
