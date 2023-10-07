//
//  MediaLibraryServiceErrorDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuGenericExtensions
import KyuNetworkExtensions
import Moya

struct MediaLibraryServiceErrorDTO: MediaLibraryServiceErrorProtocol, KSPNetworkErrorProtocol {
	@CodableIgnored var data: Data?
	@CodableIgnored var request: URLRequest?
	@CodableIgnored var response: HTTPURLResponse?
	
	let code: String
	let message: String
}
