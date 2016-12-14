//
//  NewsPreviewCD+CoreDataProperties.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 14.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreData


extension NewsPreviewCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsPreviewCD> {
        return NSFetchRequest<NewsPreviewCD>(entityName: "NewsPreviewCD");
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var published: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var imageData: NSData?

}
