//
//  NewsTableViewController.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 13.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class NewsTableViewController: CoreDataTableViewController {
	
	var context: NSManagedObjectContext! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 50
		
		refreshControl = UIRefreshControl()
		refreshControl?.attributedTitle = NSAttributedString(string: "Обновление новостей...")
		refreshControl?.addTarget(self, action: #selector(updateNews), for: .valueChanged)
		
		setupFetchController()
		
		updateNews()
		
	}
	
	private func setupFetchController() {
		
		let request: NSFetchRequest<NewsPreviewCD> = NewsPreviewCD.fetchRequest()
		request.predicate = NSPredicate(format: "TRUEPREDICATE")
		request.sortDescriptors = [NSSortDescriptor(key: "published", ascending: false)]
		
		fetchedResultController = NSFetchedResultsController<NSFetchRequestResult>(
			fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
		
	}
	
	@objc private func updateNews() {
		
		if let refreshC = refreshControl, !refreshC.isRefreshing {
			refreshC.beginRefreshing()
		}
		
		MeduzaAPI.getNewsList(withChrono: .news, newsCount: 20) { newsPreviewList, error in
			if let documents = newsPreviewList?.documents {
				DispatchQueue.global(qos: .userInitiated).async {
					NewsPreviewCD.updateDataBase(withNewsPreviewList: documents)
					DispatchQueue.main.async {
						self.refreshControl?.endRefreshing()
					}
				}
			}
		}
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.newsCell, for: indexPath)
		
		if let cell = cell as? NewsTableViewCell {
			if let newsPreviewCD = fetchedResultController?.object(at: indexPath) as? NewsPreviewCD {
				cell.newsPreview = newsPreviewCD
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: StoryBoard.showNewsSegue, sender: tableView.cellForRow(at: indexPath))
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let identifier = segue.identifier, identifier == StoryBoard.showNewsSegue {
			if let newsVC = segue.destination as? NewsViewController {
				if let cell = sender as? NewsTableViewCell,
					let newsPreview = cell.newsPreview, let url = newsPreview.url {
					newsVC.newsURL = URL(string: url.getMeduzaAPIURL())
				}
			}
		}
	}
	
	private struct StoryBoard {
		static let newsCell = "News Cell"
		static let showNewsSegue = "Show News"
	}
	
}
