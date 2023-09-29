//
//  MediaLibraryService.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions
import Moya

public var sharedAPIKey = ""

public class MediaLibraryService: MediaLibraryServiceProtocol {
	public static var moduleName: String = "KyuNetworkExtensions-Client.MediaLibraryService"
	
	var provider: KSPNetworkProvider<
		MediaLibraryAPITarget,
		MediaLibraryServiceErrorDTO
	>
	
	public init(apiKey: String) {
		let provider = KSPNetworkProvider<
			MediaLibraryAPITarget,
			MediaLibraryServiceErrorDTO
		>()
		
		sharedAPIKey = apiKey
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
			route: .apodByDate(date: date),
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
		print("api_key: \(sharedAPIKey)")
		
		await withCheckedContinuation { continuation in
			continuation.resume()
		}
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
		
		await withCheckedContinuation { continuation in
			sharedAPIKey = "DEMO_KEY"
			continuation.resume()
		}
	}
}
