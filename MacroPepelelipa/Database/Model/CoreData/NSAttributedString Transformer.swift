//
//  NSAttributedString Transformer.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

// 1. Subclass from `NSSecureUnarchiveFromDataTransformer`
@objc(NSAttributedStringTransformer)
final class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {

    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: NSAttributedStringTransformer.self))

    // 2. Make sure `NSAttributedString` is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = NSAttributedStringTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
