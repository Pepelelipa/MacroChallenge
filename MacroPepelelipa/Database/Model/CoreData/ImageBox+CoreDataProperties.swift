//
//  ImageBox+CoreDataProperties.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 10/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//
//swiftlint:disable all

import Foundation
import CoreData


extension ImageBox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageBox> {
        return NSFetchRequest<ImageBox>(entityName: "ImageBox")
    }

    @NSManaged public var height: Float
    @NSManaged public var imagePath: String?
    @NSManaged public var width: Float
    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var z: Float
    @NSManaged public var id: UUID?
    @NSManaged public var note: Note?

}

extension ImageBox : Identifiable {

}
