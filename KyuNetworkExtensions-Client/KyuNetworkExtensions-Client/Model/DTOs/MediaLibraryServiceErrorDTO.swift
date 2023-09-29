//
//  MediaLibraryServiceErrorDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions

struct MediaLibraryServiceErrorDTO: Decodable, Error {
	let code: String
	let message: String
}
