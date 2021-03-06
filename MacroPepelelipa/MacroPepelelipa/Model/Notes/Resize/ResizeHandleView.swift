//
//  ResizeHandleView.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 30/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

internal class ResizeHandleView: UIView {
    
    // MARK: - Variables and Constants
    
    private var corner: CornerEnum
    private let constant: CGFloat = 40
        
    internal unowned var referenceView: BoxView
    internal unowned var receiver: ResizeHandleReceiver
//    internal unowned var owner: NotesViewController
    internal let minimumWidht: CGFloat = 100
    internal let minimumHeight: CGFloat = 35
    
    private var scale: CGFloat {
        return 100/receiver.receiverView.frame.width
    }
    
    private var size: CGSize {
        return .init(width: 20, height: 20)
    }
    
    private lazy var origin: CGPoint = {
        var temp = referenceView.frame.getCornerPosition(corner)
        temp.x -= size.width/2
        temp.y -= size.height/2
        let diff: CGFloat = size.width/2.82 
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
    
    // MARK: - Initializers
    
    internal init(referenceView: BoxView, receiver: ResizeHandleReceiver, corner: CornerEnum) {
        self.referenceView = referenceView
        self.receiver = receiver
        self.corner = corner
        
        super.init(frame: .zero)
        
        self.frame = .init(origin: origin, size: size)
        self.backgroundColor = .clear
    }
    
    required convenience init?(coder: NSCoder) {
        guard let referenceView = coder.decodeObject(forKey: "referenceView") as? BoxView,
            let receiver = coder.decodeObject(forKey: "receiver") as? ResizeHandleReceiver,
            let corner = coder.decodeObject(forKey: "corner") as? CornerEnum else {
                    return nil
            }
        self.init(referenceView: referenceView, receiver: receiver, corner: corner)
    }
    
    // MARK: - Override functions
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        UIColor.actionColor?.setFill()
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let width: CGFloat = constant/2 + 32.0 * scale
        let radius = max(rect.width/2, rect.height/2) - width/2
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        path.lineWidth = width
        path.fill()
    }
    
    // MARK: - Functions
    
    ///Update the view Size and your resize handles
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
        receiver.uptadeResizeHandles()
        receiver.updateExclusionPaths()
    }
    
    /**
     Create a resize handle for each corner of the view
     - Parameters:
        - view: The view that will receive the resize handle
        - handlesArray: Owners Array of Handle View
        - owner : The View Controller of the reciving view
     */
    internal static func createResizeHandleView(on view: BoxView, handlesArray: inout [ResizeHandleView], inside receiver: ResizeHandleReceiver) {
        for corner in CornerEnum.allCases {
            let resizeView = ResizeHandleView(referenceView: view, receiver: receiver, corner: corner)
            resizeView.addGestureRecognizer(UIPanGestureRecognizer(target: resizeView, action: #selector(resizeView.dragHandle(_:))))
            handlesArray.append(resizeView)
            receiver.textView.addSubview(resizeView)
        }
    }
    
    ///Update the Resize Handle Position
    internal func updatePosition() {
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
    
    // MARK: - Objective-C functions
    
    ///Handles the Pan Gesture of the resize handle
    @objc private func dragHandle(_ sender: UIPanGestureRecognizer) {
        self.center = sender.location(in: receiver.textView)
        updateReferenceView()
    }
}
