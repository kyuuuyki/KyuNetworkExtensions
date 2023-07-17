//
//  KSPNetworkErrorProtocol.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

public protocol KSPNetworkErrorProtocol: Decodable, Error {
	var statusCode: Int { get set }
	
	init(response: Response?)
	init(moyaError: MoyaError)
}
