//
//  MediaLibraryServiceErrorProtocol.swift
//  KyuNetworkExtensions-Client
//

import Foundation

public protocol MediaLibraryServiceErrorProtocol: Error {
	var code: String { get }
	var message: String { get }
}
