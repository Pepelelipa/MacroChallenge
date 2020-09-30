//
//  MarkupTextView.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian, 
//             Leonardo Amorim de Oliveira and 
//             Pedro Henrique Guedes Silveira on 16/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextView: UITextView {
    
    private var animator: UIDynamicAnimator?
    private var snap: UISnapBehavior?
    private var imageView: UIImageView?
    private var initialCenter = CGPoint()
    
    var textBoxes: [TextBoxView] = []
    
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
    
    public func clearIndicatorCharacters() -> Bool {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return false
        }
        return delegate.clearIndicatorCharacters(self)
    }
    
    public func addList(of type: ListStyle, _ lineCleared: Bool) {
        guard let delegate = self.delegate as? MarkupTextViewDelegate else {
            return
        }
        
        switch type {
        case .bullet:
            delegate.addBulletList(on: self, lineCleared)
        case .numeric:
            delegate.addNumericList(on: self, lineCleared)
        case .quote:
            delegate.addQuote(on: self, lineCleared)
        }
    }
    
    func addTextBox(with frame: CGRect) {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        
        let textBox = TextBoxView(frame: frame)
        textBox.addGestureRecognizer(panGesture)
        textBox.addGestureRecognizer(tapGesture)
        self.textBoxes.append(textBox)
        self.addSubview(textBox)
    }
    
    @IBAction private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if let ownerView = gestureRecognizer.view as? TextBoxView {
            ownerView.canEdit = true
            ownerView.backgroundColor = .blue
            
        }
    }
    
    @IBAction private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        guard let ownerView = gestureRecognizer.view else {
            return
        }
        
        let translation = gestureRecognizer.translation(in: self)
        
        if gestureRecognizer.state == .began {
            initialCenter = ownerView.center
        }
        
        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            ownerView.center = newCenter
        } else {
            ownerView.center = initialCenter
        }
    }
}
