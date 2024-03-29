//
//  MediaLibraryServiceProtocol.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuGenericExtensions

public protocol MediaLibraryServiceProtocol: ModuleProtocol {
	func checkAPOD(date: Date) async throws
	func getAPOD(date: Date) async throws -> MediaLibraryAPODItemProtocol
	func getAPODList(fromDate: Date, toDate: Date) async throws -> [MediaLibraryAPODItemProtocol]
}
