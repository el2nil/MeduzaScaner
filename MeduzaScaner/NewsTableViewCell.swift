//
//  NewsTableViewCell.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 14.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
	
	var newsPreview: NewsPreviewCD? { didSet { updateUI() } }
	
	var imageURL: URL? {
		return URL(string: newsPreview?.imageURL ?? "")
	}
	
	@IBOutlet weak var imagePreview: UIImageView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var createdLabel: UILabel!
	
	private func updateUI() {
		
		label.text = nil
		createdLabel.text = nil
		imagePreview.image = nil
		
		label.text = newsPreview?.title
		
		if let published = newsPreview?.published as? Date {
			let formatter = DateFormatter()
			if Date().timeIntervalSince(published) > 24*60*60 {
				formatter.dateStyle = .short
			} else {
				formatter.timeStyle = .short
			}
			createdLabel.text = formatter.string(from: published)
		} else {
			createdLabel.text = ""
		}
		
//		if let imageData = newsPreview?.imageData,
//			let image = UIImage(data: imageData as Data) {
//			imagePreview.image = image
//			layoutSubviews()
//		} else
		if let url = imageURL {
			setImage(url: url)
		}
	}
	
	private func setImage(url: URL) {
		DispatchQueue.global(qos: .userInitiated).async { [weak weakself = self] in
			if let image = imageCache.object(forKey: url as NSURL) {
				DispatchQueue.main.async {
					weakself?.imagePreview.image = image
				}
			} else if let data = try? Data(contentsOf: url) {
				DispatchQueue.main.async {
					if url == weakself?.imageURL {
						if let image = UIImage(data: data) {
							imageCache.setObject(image, forKey: url as NSURL)
						}
						weakself?.imagePreview.image = UIImage(data: data)
					}
				}
			}
			
		}
	}
	
}
