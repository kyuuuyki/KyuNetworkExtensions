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
	public func getAPOD(date: Date) async throws -> MediaLibraryAPODItemProtocol {
		try await provider.requestObject(
			type: MediaLibraryAPODItemDTO.self,
			route: .apodByDate(date: date),
			errorPath: "error",
			retries: 1
		)
	}
}

extension MediaLibraryService: KSPNetworkHandler {
	public func prerequisiteProcessesForRequest<T, E>(
		for provider: KSPNetworkProvider<T, E>,
		route: T
	) async where T: TargetType, E: DecodableError {
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
	) async where T: TargetType, E: DecodableError {
		print("------------------------------------------------------------")
		print("KSPAsyncNetworkHandler - Before Retry Request")
		print("------------------------------------------------------------")
		print(route)
		print(error)
		
		await withCheckedContinuation { continuation in
			sharedAPIKey = "DEMO_KEY"
			continuation.resume()
		}
	}
}
