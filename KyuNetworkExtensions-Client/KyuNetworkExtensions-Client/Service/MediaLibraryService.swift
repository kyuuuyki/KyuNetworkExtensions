//
//  MediaLibraryService.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions
import Moya

public class MediaLibraryService: MediaLibraryServiceProtocol {
	public static var moduleName: String = "KyuNetworkExtensions-Client.MediaLibraryService"
	
	let apiKey: String
	var provider: KSPNetworkProvider<
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
		self.provider.handler = self
	}
	
	// MARK: - GET APOD
	public enum GetAPODError: Error {
		case notFound
	}
	public func getAPOD(date: Date) async throws -> MediaLibraryAPODItemProtocol {
		let item = try await provider.requestObject(
			type: MediaLibraryAPODItemDTO.self,
			route: .apodByDate(apiKey: apiKey, date: date),
			retries: 1
		)
		if let apodItem = MediaLibraryAPODItem(item: item) {
			return apodItem
		}
		throw GetAPODError.notFound
	}
}

extension MediaLibraryService: KSPNetworkHandler {
	public func prerequisiteProcessesForRequest<T, E>(
		for provider: KSPNetworkProvider<T, E>,
		route: T
	) async where T: TargetType, E: KSPNetworkErrorProtocol {
		print("------------------------------------------------------------")
		print("KSPAsyncNetworkHandler - Before Request")
		print("------------------------------------------------------------")
		print(route)
	}
	
	public func prerequisiteProcessesForRetryRequest<T, E>(
		for provider: KSPNetworkProvider<T, E>,
		route: T,
		error: Error
	) async where T: TargetType, E: KSPNetworkErrorProtocol {
		print("------------------------------------------------------------")
		print("KSPAsyncNetworkHandler - Before Retry Request")
		print("------------------------------------------------------------")
		print(route)
		print(error.localizedDescription)
	}
}
