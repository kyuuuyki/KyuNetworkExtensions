//
//  MediaLibraryServiceErrorDTO.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions
import Moya

struct MediaLibraryServiceErrorDTO: KSPNetworkErrorProtocol {
	// MARK: Protocol Conformance
	var statusCode: Int = 0
	let code: String?
	let message: String?
	
	// MARK: Initialize
	init(statusCode: Int, code: String?, message: String?) {
		self.statusCode = statusCode
		self.code = code
		self.message = message
	}
	
	init(response: Response?) {
		if let response {
			let moyaError = MoyaError.statusCode(response)
			self.init(moyaError: moyaError)
		} else {
			let statusCode = response?.statusCode ?? 0
			self.init(statusCode: statusCode, code: nil, message: nil)
		}
	}
	
	init(moyaError: MoyaError) {
		let statusCode = moyaError.response?.statusCode ?? 0
		let code = "\(moyaError.errorCode)"
		let message = moyaError.errorDescription
		self.init(statusCode: statusCode, code: code, message: message)
	}
}
