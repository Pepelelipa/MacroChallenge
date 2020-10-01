//
//  CGRectExtension.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 01/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreGraphics

internal extension CGRect {
    var topLeftCorner: CGPoint {
        return CGPoint(x: self.minX, y: self.minY)
    }
    
    var topRightCorner: CGPoint {
        return CGPoint(x: self.maxX, y: self.minY)
    }
    
    var bottomLeftCorner: CGPoint {
        return CGPoint(x: self.minX, y: self.maxY)
    }
    
    var bottomRightCorner: CGPoint {
        return CGPoint(x: self.maxX, y: self.maxY)
    }
    
    var corners: [CGPoint] {
        return [topLeftCorner, topRightCorner, bottomLeftCorner, bottomRightCorner]
    }
    
    func getCornerPosition(_ corner: CornerEnum) -> CGPoint {
        switch corner {
        case .topLeft:
            return self.topLeftCorner
        case .topRight:
            return self.topRightCorner
        case .bottomLeft:
            return self.bottomLeftCorner
        case .bottomRight:
            return self.bottomRightCorner
        }
    }
    
    init(topLeft: CGPoint, bottomRight: CGPoint) {
        self.init(x: topLeft.x, y: topLeft.y, width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
    }
    
    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
