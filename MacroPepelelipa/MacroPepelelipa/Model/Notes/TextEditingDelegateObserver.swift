//
//  TextViewDelegateObserver.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

internal protocol TextEditingDelegateObserver: class {
    func textEditingDidBegin()
    func textEditingDidEnd()
}
