//
//  MediaLibraryAPODItemDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions

struct MediaLibraryAPODItemDTO: Decodable, MediaLibraryAPODItemProtocol {
	let date: Date
	let title: String
	let description: String?
	let imageUrl: URL
	let imageHDUrl: URL?
	let link: URL?
	
	enum CodingKeys: String, CodingKey {
		case date
		case explanation
		case hdurl
		case title
		case url
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let date = try container.decodeIfPresent(String.self, forKey: .date)
		let explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
		let hdurl = try container.decodeIfPresent(String.self, forKey: .hdurl)
		let title = try container.decode(String.self, forKey: .title)
		let url = try container.decode(String.self, forKey: .url)
		
		guard let date,
			  let date = Date(string: date, format: "yyyy-MM-dd")
		else {
			throw DecodingError.dataCorruptedError(
				forKey: .date,
				in: container,
				debugDescription: "Cannot convert DTO's date to Swift's date"
			)
		}
		
		guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: url)
		else {
			throw DecodingError.dataCorruptedError(
				forKey: .url,
				in: container,
				debugDescription: "Cannot convert DTO's url to Swift's url"
			)
		}
		
		self.date = date
		self.title = title
		self.description = explanation
		self.imageUrl = url
		self.imageHDUrl = URL(string: hdurl ?? "")
		self.link = URL(string: "https://apod.nasa.gov/")
	}
}
