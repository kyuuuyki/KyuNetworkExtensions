//
//  KSPNetworkErrorDecodable.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

public protocol KSPNetworkErrorDecodable: Decodable, Error {
	var statusCode: Int { get set }
	
	init(response: Response?)
	init(moyaError: MoyaError)
}
