//
//  MeduzaNewsCollection.swift
//  MeduzaScaner
//
//  Created by Danil Denshin on 13.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

fileprivate let meduzaAPIURL = "https://meduza.io/api/v3/"

extension String {
	func getMeduzaURL() -> String {
		return "https://meduza.io" + self
	}
	func getMeduzaAPIURL() -> String {
		return meduzaAPIURL + self
	}
}

class MeduzaAPI {
	
	class func getNews(url: URL, complitionHandler: @escaping (News?, Error?) -> Void) {
		
		Alamofire.request(url).responseJSON { (response) in
			switch response.result {
			case .failure(let error):
				complitionHandler(nil, error)
			case .success(let value):
				if let json = value as? JSON {
					let news = News(json: json)
					complitionHandler(news, nil)
				} else {
					print("Error: can't parse response")
					complitionHandler(nil, nil)
				}
			}
		}
	}
	
	
	class func getNewsList(
		withChrono chrono: ChronoKeys,
		newsCount: Int,
		complitionHandler: @escaping (NewsPreviewList?, Error?) -> Void) {
		
		let searchString = meduzaAPIURL + "search?"
			+ parameter(MeduzaSearchKeys.chrono, withValue: chrono.rawValue)
			+ "&" + parameter(MeduzaSearchKeys.page, withValue: "0")
			+ "&" + parameter(MeduzaSearchKeys.per_page, withValue: String(newsCount))
			+ "&locale=ru"
		
		Alamofire.request(searchString).responseJSON { (response) in
			switch response.result {
			case .failure(let error):
				complitionHandler(nil, error)
			case .success(let value):
				if let json = value as? JSON {
					let newsList = NewsPreviewList(json: json)
					complitionHandler(newsList, nil)
				} else {
					print("Error: can't parse response")
					complitionHandler(nil, nil)
				}
			}
		}
	}
}

struct News: Decodable {
	var url: String?
	var title: String?
	private var relativeImageURL: String?
	var imageURL: URL?
	var content: String?
	private var publishedSeconds: Double?
	var published: Date?
	
	init?(json: JSON) {
		url = "root.url" <~~ json
		title = "root.title" <~~ json
		relativeImageURL = "root.image.large_url" <~~ json
		if relativeImageURL != nil {
			imageURL = URL(string: relativeImageURL!.getMeduzaURL())
		}
		content = "root.content.body" <~~ json
		publishedSeconds = "root.published_at" <~~ json
		if publishedSeconds != nil {
			published = Date(timeIntervalSince1970: publishedSeconds!)
		}
	}
}

struct NewsPreviewList: Decodable {
	var collection: [String]?
	var documents: [NewsPreview]?
	
	init?(json: JSON) {
		collection = "collection" <~~ json
		let documentsDictionary: [String: NewsPreview]? = "documents" <~~ json
		documents = documentsDictionary?.map({$0.value})
	}
}

struct NewsPreview: Decodable {
	var url: String?
	var title: String?
	private var relativeImageURL: String?
	var imageURL: URL?
	private var publishedSeconds: Double?
	var published: Date?
	
	init?(json: JSON) {
		url = "url" <~~ json
		title = "title" <~~ json
		relativeImageURL = "image.small_url" <~~ json
		if relativeImageURL != nil {
			imageURL = URL(string: relativeImageURL!.getMeduzaURL())
		}
		publishedSeconds = "published_at" <~~ json
		if publishedSeconds != nil {
			published = Date(timeIntervalSince1970: publishedSeconds!)
		}
		
		
	}
}

fileprivate func parameter(_ parameter: String, withValue value: String) -> String {
	return parameter + "=" + value
}

struct MeduzaSearchKeys {
	
	static let page = "page"
	static let per_page = "per_page"
	static let locale = "locale"
	static let chrono = "chrono"
	static let seatch = "search"
}

enum ChronoKeys: String {
	case news = "news"
	case cards = "cards"
	case articles = "articles"
	case shapito = "shapito"
	case polygon = "polygon"
}

extension String {
	
	var html2AttributedString: NSAttributedString? {
		guard let data = data(using: .utf8) else { return nil }
		do {
			return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
		} catch let error as NSError {
			print(error.localizedDescription)
			return  nil
		}
	}
	var html2String: String {
		return html2AttributedString?.string ?? ""
	}
}



