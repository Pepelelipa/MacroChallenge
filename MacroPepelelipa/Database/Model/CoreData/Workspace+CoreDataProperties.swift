//
//  Workspace+CoreDataProperties.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 22/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//
//swiftlint:disable all

import Foundation
import CoreData

extension Workspace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workspace> {
        return NSFetchRequest<Workspace>(entityName: "Workspace")
    }

    @NSManaged public var name: String?
    @NSManaged public var isEnabled: Bool
    @NSManaged public var notebooks: NSOrderedSet?

}

// MARK: Generated accessors for notebooks
extension Workspace {

    @objc(insertObject:inNotebooksAtIndex:)
    @NSManaged public func insertIntoNotebooks(_ value: Notebook, at idx: Int)

    @objc(removeObjectFromNotebooksAtIndex:)
    @NSManaged public func removeFromNotebooks(at idx: Int)

    @objc(insertNotebooks:atIndexes:)
    @NSManaged public func insertIntoNotebooks(_ values: [Notebook], at indexes: NSIndexSet)

    @objc(removeNotebooksAtIndexes:)
    @NSManaged public func removeFromNotebooks(at indexes: NSIndexSet)

    @objc(replaceObjectInNotebooksAtIndex:withObject:)
    @NSManaged public func replaceNotebooks(at idx: Int, with value: Notebook)

    @objc(replaceNotebooksAtIndexes:withNotebooks:)
    @NSManaged public func replaceNotebooks(at indexes: NSIndexSet, with values: [Notebook])

    @objc(addNotebooksObject:)
    @NSManaged public func addToNotebooks(_ value: Notebook)

    @objc(removeNotebooksObject:)
    @NSManaged public func removeFromNotebooks(_ value: Notebook)

    @objc(addNotebooks:)
    @NSManaged public func addToNotebooks(_ values: NSOrderedSet)

    @objc(removeNotebooks:)
    @NSManaged public func removeFromNotebooks(_ values: NSOrderedSet)

}

extension Workspace : Identifiable {

}
