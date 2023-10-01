//
//  KSPNetworkErrorProtocol.swift
//  KyuNetworkExtensions
//

import Foundation

public protocol KSPNetworkErrorProtocol: Decodable, Error {
	var response: HTTPURLResponse? { get set }
}
