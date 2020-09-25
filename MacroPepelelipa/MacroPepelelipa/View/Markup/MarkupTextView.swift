//
//  MarkupTextView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextView: UITextView {
    
    private var animator: UIDynamicAnimator?
    private var snap: UISnapBehavior?
    private var imageView: UIImageView?
    
    init(frame: CGRect, delegate: MarkupTextViewDelegate? = nil) {
        super.init(frame: frame, textContainer: nil)
        
        self.delegate = delegate
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "Background")
        self.textColor = UIColor(named: "Placeholder")
        self.tintColor = UIColor(named: "Highlight")
        
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            imageView = checkTouch(touch)
        }
    }
    
    /**
     This method checks if it finds a UIImageView on the same location were the user touched the screen. If a UIImageView was found, the image is returned. If not, returns nil.
     
     - Parameter touch: The UITouch which location will be checked.
     
     - Returns: A UIImageView if an image was found on the touch location or nil if nothing was found.
     */
    private func checkTouch(_ touch: UITouch) -> UIImageView? {
        for subview in subviews {
            if let image = subview as? UIImageView {
                if image.frame.contains(touch.location(in: self)) {
                    return subview as? UIImageView
                }
            }
        }
        return nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if let snap = snap {
                animator?.removeBehavior(snap)
            }

            guard let image = imageView else {
                return
            }
            snap = UISnapBehavior(item: image, snapTo: location)

            if let snap = snap {
                animator?.addBehavior(snap)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let snap = snap {
                animator?.removeBehavior(snap)
                self.snap = nil
            }
            if let frame = imageView?.frame {
                let exclusionPath = UIBezierPath(rect: frame)
                self.textContainer.exclusionPaths = [exclusionPath]
            }
            imageView = nil
        }
    }
    
    public func clearIndicatorCharacters() {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return
        }
        delegate.clearIndicatorCharacters(self)
    }
    
}
