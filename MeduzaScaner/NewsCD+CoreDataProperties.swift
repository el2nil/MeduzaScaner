//
//  NewsCD+CoreDataProperties.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 14.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreData


extension NewsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCD> {
        return NSFetchRequest<NewsCD>(entityName: "NewsCD");
    }

    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var content: String?
    @NSManaged public var published: NSDate?
    @NSManaged public var imageData: NSData?

}
