//
//  Note+CoreDataProperties.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: NSAttributedString?
    @NSManaged public var title: NSAttributedString?
    @NSManaged public var images: NSSet?
    @NSManaged public var notebook: Notebook?
    @NSManaged public var textBoxes: NSSet?

}

// MARK: Generated accessors for images
extension Note {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageBox)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageBox)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for textBoxes
extension Note {

    @objc(addTextBoxesObject:)
    @NSManaged public func addToTextBoxes(_ value: TextBox)

    @objc(removeTextBoxesObject:)
    @NSManaged public func removeFromTextBoxes(_ value: TextBox)

    @objc(addTextBoxes:)
    @NSManaged public func addToTextBoxes(_ values: NSSet)

    @objc(removeTextBoxes:)
    @NSManaged public func removeFromTextBoxes(_ values: NSSet)

}

extension Note : Identifiable {

}
