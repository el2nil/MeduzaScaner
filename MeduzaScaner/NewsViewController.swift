//
//  NewsViewController.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 14.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class NewsViewController: UIViewController {
	
	var newsURL: URL?
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var headerLabel: UILabel!
	@IBOutlet weak var createdLabel: UILabel!
	@IBOutlet weak var newsTextLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	
	private func updateUI() {
		
		imageView.image = nil
		headerLabel.text = nil
		createdLabel.text = nil
		newsTextLabel.text = nil
		
		MBProgressHUD.showAdded(to: view, animated: true)
		if newsURL != nil {
			MeduzaAPI.getNews(url: newsURL!) { [weak self] news, error in
				
				
				guard news != nil, let newsCD = NewsCD.getNewsCD(forNews: news!) else { return }
				
				
				var imageData: Data?
				if let imageURLString = newsCD.imageURL, let imageURL = URL(string: imageURLString) {
					imageData = try? Data(contentsOf: imageURL)
				}
				
				DispatchQueue.main.async {
					self?.headerLabel.text = newsCD.title
					
					if let published = newsCD.published as? Date {
						let formatter = DateFormatter()
						if Date().timeIntervalSince(published) > 24*60*60 {
							formatter.dateStyle = .short
						} else {
							formatter.timeStyle = .short
						}
						self?.createdLabel.text = formatter.string(from: published)
					} else {
						self?.createdLabel.text = ""
					}
					
					self?.newsTextLabel.attributedText = newsCD.content?.html2AttributedString
					
					if let imageData = imageData {
						self?.imageView.image = UIImage(data: imageData)
					}
					
					if self != nil {
						MBProgressHUD.hide(for: self!.view, animated: true)
					}
				}
			}
		}
	}
	
}
