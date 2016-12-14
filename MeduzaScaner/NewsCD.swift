//
//  NewsCD+CoreDataClass.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 14.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NewsCD)
public class NewsCD: NSManagedObject {
	
	class func getNewsCD(forNews news: News) -> NewsCD? {
		
		let context: NSManagedObjectContext! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		
		guard news.url != nil else { return nil }
		
		let request: NSFetchRequest<NewsCD> = NewsCD.fetchRequest()
		request.predicate = NSPredicate(format: "url = %@", news.url!)
		if let result = (try? context.fetch(request))?.first {
			return result
		} else {
			let newsCD = NewsCD(context: context)
			newsCD.url = news.url
			newsCD.title = news.title
			newsCD.imageURL = news.imageURL?.absoluteString
//			if let url = news.imageURL,
//				let data = try? Data(contentsOf: url) {
//				newsCD.imageData = data as NSData
//			}
			
			if let published = news.published {
				newsCD.published = published as NSDate
			}
			newsCD.content = news.content
			do {
				try context.save()
				return newsCD
			}
			catch {
				print("Error saving news: \(error)")
				return nil
			}
		}
	}
	
}
