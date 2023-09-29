//
//  MediaLibraryAPODItem.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuGenericExtensions

struct MediaLibraryAPODItem: MediaLibraryAPODItemProtocol {
	let date: Date
	let title: String
	let description: String?
	let imageUrl: URL
	let imageHDUrl: URL?
	let link: URL?
	
	init?(item: MediaLibraryAPODItemDTO) {
		guard let dateString = item.date,
			  let date = Date(string: dateString, format: "yyyy-MM-dd")
		else {
			return nil
		}
		
		guard let encodedUrlString = item.url.addingPercentEncoding(
				withAllowedCharacters: .urlQueryAllowed
			  ),
			  let url = URL(string: encodedUrlString)
		else {
			return nil
		}
		
		self.date = date
		self.title = item.title
		self.description = item.explanation
		self.imageUrl = url
		self.imageHDUrl = URL(string: item.hdurl ?? "")
		self.link = URL(string: "https://apod.nasa.gov/")
	}
}
