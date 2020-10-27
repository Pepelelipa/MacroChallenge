//
//  TextBox+CoreDataProperties.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 27/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//
//swiftlint:disable all

import Foundation
import CoreData


extension TextBox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextBox> {
        return NSFetchRequest<TextBox>(entityName: "TextBox")
    }

    @NSManaged public var height: Float
    @NSManaged public var text: NSAttributedString?
    @NSManaged public var width: Float
    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var z: Float
    @NSManaged public var note: Note?

}

extension TextBox : Identifiable {

}
