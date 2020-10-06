//
//  TextViewDelegateObserver.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal protocol TextEditingDelegateObserver: class {
    /**
     The method that is initialized when the observer sends the notification that the text editing has started
     */
    func textEditingDidBegin()
    /**
     The method that is initialized when the observer sends the notification that the text editing has ended
     */
    func textEditingDidEnd()
    /**
     The method that is initialized when the observer sends the notification that the text has received a \n
     */
    func textReceivedEnter()
}

extension TextEditingDelegateObserver {
    func textEditingDidBegin() {
        
    }
    func textEditingDidEnd() {
        
    }
    func textReceivedEnter() {
        
    }
}
