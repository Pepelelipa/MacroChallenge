//
//  TextViewDelegateObserver.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 28/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal protocol TextEditingDelegateObserver: AnyObject {
    
    ////The method that is initialized when the observer sends the notification that the text editing has started
    func textEditingDidBegin()
    
    ///The method that is initialized when the observer sends the notification that the text editing has ended
    func textEditingDidEnd()
}

extension TextEditingDelegateObserver {
    func textEditingDidBegin() {}
    func textEditingDidEnd() {}
}
