//
//  ResizeHandleFunctions.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 10/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

internal class ResizeHandleFunctions {
    
    private weak var owner: ResizeHandleReceiver?
    
    internal init(owner: ResizeHandleReceiver) {
        self.owner = owner 
    }
    
    /**
     Adds and position the resize handles in the box view
     - Parameters
        - boxView: The Box View who will receive the resize handle.
     */
    internal func placeResizeHandles(boxView: BoxView, resizeHandles: inout [ResizeHandleView]) {
        if !resizeHandles.isEmpty {
            resizeHandles.forEach { (resizeHandle) in
                resizeHandle.removeFromSuperview()
            }
            resizeHandles.removeAll()
        }
        if let receiver = owner {
            ResizeHandleView.createResizeHandleView(on: boxView, handlesArray: &resizeHandles, inside: receiver)
            resizeHandles[0].setNeedsDisplay()
        }
    }
    
    ////Delete all resize handles
    internal func cleanResizeHandles(resizeHandles: inout [ResizeHandleView]) {
        if !resizeHandles.isEmpty {
            resizeHandles.forEach { (resizeHandle) in
                resizeHandle.removeFromSuperview()
            }
            resizeHandles.removeAll()
        }
    }
}
