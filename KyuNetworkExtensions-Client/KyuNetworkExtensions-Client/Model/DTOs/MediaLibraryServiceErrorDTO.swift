//
//  MediaLibraryServiceErrorDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions

struct MediaLibraryServiceErrorDTO: Decodable, MediaLibraryServiceErrorProtocol {
	let code: String
	let message: String
}
