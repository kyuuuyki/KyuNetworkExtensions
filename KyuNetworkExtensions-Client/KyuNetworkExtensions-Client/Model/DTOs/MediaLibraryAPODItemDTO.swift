//
//  MediaLibraryAPODItemDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions

struct MediaLibraryAPODItemDTO: Decodable {
	let date: String?
	let explanation: String?
	let hdurl: String?
	let mediaType: String?
	let serviceVersion: String?
	let title: String
	let url: String
	
	enum CodingKeys: String, CodingKey {
		case date
		case explanation
		case hdurl
		case mediaType = "media_type"
		case serviceVersion = "service_version"
		case title
		case url
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		date = try container.decodeIfPresent(String.self, forKey: .date)
		explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
		hdurl = try container.decodeIfPresent(String.self, forKey: .hdurl)
		mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType)
		serviceVersion = try container.decodeIfPresent(String.self, forKey: .serviceVersion)
		title = try container.decode(String.self, forKey: .title)
		url = try container.decode(String.self, forKey: .url)
	}
}
