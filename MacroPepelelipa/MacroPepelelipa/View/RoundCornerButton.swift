//
//  RoundCornerButton.swift
//  MacroPepelelipa
//
//  Created by Pedro Farina on 14/10/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class RoundCornerButton: UIButton {
    internal var textColor: UIColor? {
        didSet {
            updateDrawProperties()
        }
    }
    internal var fillColor: UIColor? {
        didSet {
            updateDrawProperties()
        }
    }
    internal var borderColor: UIColor? {
        didSet {
            updateDrawProperties()
        }
    }
    internal var cornerRadius: CGFloat {
        didSet {
            updateDrawProperties()
        }
    }
    private var initializing: Bool = true

    private var borderPath: UIBezierPath?

    init(textColor: UIColor? = .white,
         fillColor: UIColor? = .purple,
         borderColor: UIColor? = nil,
         cornerRadius: CGFloat = 6) {
        self.textColor = textColor
        self.fillColor = fillColor
        self.borderColor =  borderColor
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        initializing = false
        updateDrawProperties()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func updateDrawProperties() {
        if initializing { return }
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = fillColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let borderColor = borderColor {
            borderPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            borderPath?.lineWidth = 3
            borderColor.setStroke()
        }
        borderPath?.stroke()
    }
}
