//
//  NewsPreviewCD+CoreDataClass.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 14.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NewsPreviewCD)
public class NewsPreviewCD: NSManagedObject {
	
	class func updateDataBase(withNewsPreviewList newsPreviewList: [NewsPreview]) {
		
		let context: NSManagedObjectContext! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		
		let request: NSFetchRequest<NewsPreviewCD> = NewsPreviewCD.fetchRequest()
		request.predicate = NSPredicate(format: "url in %@", newsPreviewList.flatMap({$0.url}))
		
		if let result = try? context.fetch(request) {
			let storedNewsURLSet: Set<String> = Set(result.flatMap({$0.url}))
			let newsListURLSet: Set<String> = Set(newsPreviewList.flatMap({$0.url}))
			
			let newsURLToSave = newsListURLSet.subtracting(storedNewsURLSet)
			for newsURL in newsURLToSave {
				if let index = newsPreviewList.index(where: {$0.url == newsURL }) {
					let news = NewsPreviewCD(context: context)
					news.url = newsPreviewList[index].url
					news.title = newsPreviewList[index].title
					news.imageURL = newsPreviewList[index].imageURL?.absoluteString
					news.published = newsPreviewList[index].published as NSDate?
//					if newsPreviewList[index].imageURL != nil {
//						if let data = try? Data(contentsOf: newsPreviewList[index].imageURL!) {
//							news.imageData = data as NSData
//						}
//					}
				}
			}
			try? context.save()
		}
	}

}
