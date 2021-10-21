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
            if isEnabled {
                _textColor = textColor
            }
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
            if isEnabled {
                _borderColor = borderColor
            }
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
    private var _textColor: UIColor?
    private var _borderColor: UIColor?

    init(textColor: UIColor? = .black,
         fillColor: UIColor? = nil,
         borderColor: UIColor? = nil,
         cornerRadius: CGFloat = 18) {
        self.textColor = textColor
        self._textColor = textColor
        self.fillColor = fillColor
        self.borderColor =  borderColor
        self._borderColor = borderColor
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        initializing = false
        updateDrawProperties()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func updateDrawProperties() {
        if initializing {
            return
        }
        self.setTitleColor(_textColor, for: .normal)
        self.backgroundColor = fillColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let borderColor = _borderColor {
            borderPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            borderPath?.lineWidth = 4.2
            borderColor.setStroke()
        }
        borderPath?.stroke()
    }

    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            if isEnabled {
                self.backgroundColor = fillColor
                self._borderColor = borderColor
                self._textColor = textColor
            } else {
                let unabledColor: UIColor = .darkGray
                if fillColor != nil && fillColor != .clear {
                    self.backgroundColor = unabledColor
                }
                if borderColor != nil && borderColor != .clear {
                    self._borderColor = unabledColor
                }
                self._textColor = unabledColor
            }
            updateDrawProperties()
        }
    }
}
