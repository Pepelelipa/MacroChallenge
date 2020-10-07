//
//  ImageBox+CoreDataProperties.swift
//  Database
//
//  Created by Pedro Giuliano Farina on 07/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageBox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageBox> {
        return NSFetchRequest<ImageBox>(entityName: "ImageBox")
    }

    @NSManaged public var imagePath: String?
    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var z: Float
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var note: Note?

}

extension ImageBox : Identifiable {

}
