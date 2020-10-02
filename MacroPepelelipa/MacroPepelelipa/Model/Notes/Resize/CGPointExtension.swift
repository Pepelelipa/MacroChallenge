//
//  CGPointExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 01/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        let xPosition = lhs.x - rhs.x
        let yPosition = lhs.y - rhs.y
        return CGPoint(x: xPosition, y: yPosition)
    }
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        let xPosition = lhs.x + rhs.x
        let yPosition = lhs.y + rhs.y
        return CGPoint(x: xPosition, y: yPosition)
    }
}
