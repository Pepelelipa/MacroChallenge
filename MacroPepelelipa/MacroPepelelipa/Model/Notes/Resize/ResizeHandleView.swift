//
//  ResizeHandleView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 30/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

final internal class ResizeHandleView: UIView {
    
    unowned var referenceView: BoxView
    unowned var owner: NotesViewController
    
    private var corner: CornerEnum
    
    private let constant: CGFloat = 40
    
    private var scale: CGFloat {
        return 100/owner.view.frame.width
    }
    
    private var size: CGSize {
        return .init(width: 20, height: 20)
    }
    
    private lazy var origin: CGPoint = {
        var temp = referenceView.frame.getCornerPosition(corner)
        temp.x -= size.width/2
        temp.y -= size.height/2
        let diff: CGFloat = size.width/2.82 // to position the ring tangent to the frames corner: width/2 * √2/2 :: width/2/√2
        switch corner {
        case .topLeft:
            temp.x -= diff
            temp.y -= diff
        case .topRight:
            temp.x += diff
            temp.y -= diff
        case .bottomLeft:
            temp.x -= diff
            temp.y += diff
        case .bottomRight:
            temp.x += diff
            temp.y += diff
        }
        return temp
    }()
    
    let minimumWidht: CGFloat = 120
    let minimumHeight: CGFloat = 120

    init(referenceView: BoxView, owner: NotesViewController, corner: CornerEnum) {
        self.referenceView = referenceView
        self.owner = owner
        self.corner = corner
        
        super.init(frame: .zero)
        
        self.frame = .init(origin: origin, size: size)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        UIColor.blue.setFill()
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let width: CGFloat = constant/2 + 32.0 * scale
        let radius = max(rect.width/2, rect.height/2) - width/2
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        path.lineWidth = width
        path.fill()
    }
    
    static func createResizeHandleView(on view: BoxView, handlesArray: inout [ResizeHandleView], inside owner: NotesViewController) {
        for corner in CornerEnum.allCases {
            let resizeView = ResizeHandleView(referenceView: view, owner: owner, corner: corner)
            resizeView.addGestureRecognizer(UIPanGestureRecognizer(target: resizeView, action: #selector(resizeView.dragHandle(_:))))
            handlesArray.append(resizeView)
            owner.textView.addSubview(resizeView)
        }
    }
    
    public func updatePosition() {
        switch corner {
        case .topLeft:
            self.center = referenceView.frame.topLeftCorner
        case .topRight:
            self.center = referenceView.frame.topRightCorner
        case .bottomLeft:
            self.center = referenceView.frame.bottomLeftCorner
        case .bottomRight:
            self.center = referenceView.frame.bottomRightCorner
        }
        self.setNeedsDisplay()
    }
    
    private func updateReferenceView() {
        switch corner {
        case .topLeft:
            let newWidth = referenceView.frame.maxX - self.center.x
            let newHeight = referenceView.frame.maxY - self.center.y
            let newX = newWidth < minimumWidht ? referenceView.frame.maxX - minimumWidht : self.center.x
            let newY = newHeight < minimumHeight ? referenceView.frame.maxY - minimumHeight : self.center.y
            referenceView.frame = CGRect(minX: newX, minY: newY, maxX: referenceView.frame.maxX, maxY: referenceView.frame.maxY)
        case .topRight:
            let newWidth = self.center.x - referenceView.frame.minX
            let newHeight = referenceView.frame.maxY - self.center.y
            let newX = newWidth < minimumWidht ? referenceView.frame.minX + minimumWidht : self.center.x
            let newY = newHeight < minimumHeight ? referenceView.frame.maxY - minimumHeight : self.center.y
            referenceView.frame = CGRect(minX: referenceView.frame.minX, minY: newY, maxX: newX, maxY: referenceView.frame.maxY)
        case .bottomLeft:
            let newWidht = referenceView.frame.maxX - self.center.x
            let newHeight = self.center.y - referenceView.frame.minY
            let newX = newWidht < minimumWidht ? referenceView.frame.maxX - minimumWidht : self.center.x
            let newY = newHeight < minimumHeight ? referenceView.frame.minY + minimumHeight : self.center.y
            referenceView.frame = CGRect(minX: newX, minY: referenceView.frame.minY, maxX: referenceView.frame.maxX, maxY: newY)
        case .bottomRight:
            let newWidth = self.center.x - referenceView.frame.minX
            let newHeight = self.center.y - referenceView.frame.minY
            let newX = newWidth < minimumWidht ? referenceView.frame.minX + minimumWidht : self.center.x
            let newY = newHeight < minimumHeight ? referenceView.frame.minY + minimumHeight : self.center.y
            referenceView.frame = CGRect(minX: referenceView.frame.minX, minY: referenceView.frame.minY, maxX: newX, maxY: newY)
        }
        referenceView.internalFrame = referenceView.frame
        owner.uptadeResizeHandles()
    }
    
    @objc public func dragHandle(_ sender: UIPanGestureRecognizer) {
        self.center = sender.location(in: owner.textView)
        updateReferenceView()
    }
}
