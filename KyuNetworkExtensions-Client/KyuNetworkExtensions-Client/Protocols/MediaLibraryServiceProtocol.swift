//
//  MediaLibraryServiceProtocol.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuGenericExtensions

public protocol MediaLibraryServiceProtocol: ModuleProtocol {
	func getAPOD(date: Date) async throws -> MediaLibraryAPODItemProtocol
}
