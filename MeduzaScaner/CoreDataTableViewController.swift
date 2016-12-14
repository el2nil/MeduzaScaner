//
//  CoreDataTableViewController.swift
//  MrScrooge
//
//  Created by Danil Denshin on 07.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>? {
		didSet {
			do {
				if let frc = fetchedResultController {
					frc.delegate = self
					try frc.performFetch()
				}
				tableView.reloadData()
			} catch {
				print("NSFetchedResultController.performFetch() failed: \(error)")
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultController?.sections?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultController?.sections, sections.count > 0 {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		if let sections = fetchedResultController?.sections, sections.count > 0 {
//			return sections[section].name
//		} else {
//			return nil
//		}
		return nil
	}
	
//	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//		return fetchedResultController?.sectionIndexTitles
//	}
	
//	override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//		return fetchedResultController?.section(forSectionIndexTitle: title, at: index) ?? 0
//	}
	
	// MARK: NSFetchedResultsControllerDelegate 
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer: sectionIndex) , with: .fade)
		case .delete:
			tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
		default: break
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		case .update:
			tableView.deleteRows(at: [indexPath!], with: .fade)
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		}
	}

	
}
