//
//  KSPNetworkErrorProtocol.swift
//  KyuNetworkExtensions
//

import Foundation
import KyuGenericExtensions
import Moya

public protocol KSPNetworkErrorProtocol: Decodable, Error {
	var data: Data? { get set }
	var request: URLRequest? { get set }
	var response: HTTPURLResponse? { get set }
}

internal struct KSPNetworkError: KSPNetworkErrorProtocol {
	@CodableIgnored var data: Data?
	@CodableIgnored var request: URLRequest?
	@CodableIgnored var response: HTTPURLResponse?
	
	init(response: Response) {
		self.data = response.data
		self.request = response.request
		self.response = response.response
	}
}
