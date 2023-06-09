//
//  MediaLibraryService.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions
import Moya

public struct MediaLibraryService: MediaLibraryServiceProtocol {
	public static var moduleName: String = "KyuNetworkExtensions-Client.MediaLibraryService"
	
	let apiKey: String
	let provider: KSPNetworkProvider<
		MediaLibraryAPITarget,
		MediaLibraryServiceErrorDTO
	>
	
	public init(apiKey: String) {
		let authPlugin = AccessTokenPlugin { _ in apiKey }
		let provider = KSPNetworkProvider<
			MediaLibraryAPITarget,
			MediaLibraryServiceErrorDTO
		>(
			plugins: [authPlugin]
		)
		
		self.apiKey = apiKey
		self.provider = provider
	}
	
	// MARK: - GET APOD
	public enum GetAPODError: Error {
		case notFound
	}
	public func getAPOD(date: Date) async throws -> MediaLibraryAPODItemProtocol {
		let item = try await provider.async.requestObject(
			type: MediaLibraryAPODItemDTO.self,
			route: .apodByDate(apiKey: apiKey, date: date)
		)
		if let item, let apodItem = MediaLibraryAPODItem(item: item) {
			return apodItem
		} else {
			throw GetAPODError.notFound
		}
	}
}
