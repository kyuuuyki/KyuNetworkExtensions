//
//  MediaLibraryServiceErrorDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuGenericExtensions
import KyuNetworkExtensions
import Moya

struct MediaLibraryServiceErrorDTO: KSPNetworkErrorProtocol {
	@CodableIgnored var response: HTTPURLResponse?
	
	let code: String
	let message: String
}
