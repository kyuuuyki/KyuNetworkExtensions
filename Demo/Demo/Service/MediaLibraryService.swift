//
//  MediaLibraryService.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions
import Moya

public var sharedAPIKey = "INVALID_API_KEY"
private let kValidAPIKey = "DEMO_KEY"

public class MediaLibraryService: MediaLibraryServiceProtocol {
	public static var moduleName: String = "KyuNetworkExtensions-Client.MediaLibraryService"
	
	var provider: KSPNetworkProvider<
		MediaLibraryAPITarget,
		MediaLibraryServiceErrorDTO
	>
	
	public init() {
		let provider = KSPNetworkProvider<
			MediaLibraryAPITarget,
			MediaLibraryServiceErrorDTO
		>()
		self.provider = provider
		self.provider.handler = self
	}
	
	// MARK: CHECK APOD
	public func checkAPOD(date: Date) async throws {
		try await provider.request(
			route: .apodByDate(date: date),
			errorPath: "error",
			retries: 1
		)
	}
	
	// MARK: GET APOD
	public func getAPOD(date: Date) async throws -> MediaLibraryAPODItemProtocol {
		try await provider.request(
			type: MediaLibraryAPODItemDTO.self,
			route: .apodByDate(date: date),
			errorPath: "error",
			retries: 1
		)
	}
	
	// MARK: GET APOD LIST
	public func getAPODList(
		fromDate: Date,
		toDate: Date
	) async throws -> [MediaLibraryAPODItemProtocol] {
		try await provider.request(
			type: [MediaLibraryAPODItemDTO].self,
			route: .apodByDateRange(fromDate: fromDate, toDate: toDate),
			errorPath: "error",
			retries: 1
		)
	}
}

extension MediaLibraryService: KSPNetworkHandler {
	public func prerequisiteProcessesForRequest<T, E>(
		for provider: KSPNetworkProvider<T, E>,
		route: T
	) async where T: TargetType, E: KSPNetworkErrorProtocol {
		await withCheckedContinuation { continuation in
			print("------------------------------------------------------------")
			print("KSPAsyncNetworkHandler - Before Request")
			print("------------------------------------------------------------")
			print(route)
			print("api_key: \(sharedAPIKey)")
			
			continuation.resume()
		}
	}
	
	public func prerequisiteProcessesForRetryRequest<T, E>(
		for provider: KSPNetworkProvider<T, E>,
		route: T,
		error: Error
	) async where T: TargetType, E: KSPNetworkErrorProtocol {
		await withCheckedContinuation { continuation in
			print("------------------------------------------------------------")
			print("KSPAsyncNetworkHandler - Before Retry Request")
			print("------------------------------------------------------------")
			print(route)
			print(error)
			
			if let error = error as? KSPNetworkErrorProtocol,
			   let status = error.response?.status,
			   status == .unauthorized || status == .forbidden {
				sharedAPIKey = kValidAPIKey
			}
			
			continuation.resume()
		}
	}
}
