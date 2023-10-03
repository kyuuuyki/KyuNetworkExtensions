//
//  KSPNetworkProvider.swift
//  KyuNetworkExtensions
//
//  swiftlint:disable vertical_whitespace_between_cases

import Foundation
import Moya

// MARK: - CLASS
public struct KSPNetworkProvider<T: TargetType, E: KSPNetworkErrorProtocol> {
	// MARK: MODEL
	public var provider: MoyaProvider<T>
	public weak var handler: KSPNetworkHandler?
	
	// MARK: INITIALIZATION
	public init(provider: MoyaProvider<T> = MoyaProvider<T>(), handler: KSPNetworkHandler? = nil) {
		self.provider = provider
		self.handler = handler
	}
	
	// MARK: PROVIDED PUBLIC FUNCTIONS
	/// Perform request without object mapping.
	public func requestPlain(route: T) async throws -> Response {
		await handler?.prerequisiteProcessesForRequest(for: self, route: route)
		return try await performRequest(route: route)
	}
	
	/// Perform request and map response's data to specific object type.
	public func request<O: Decodable>(
		type: O.Type,
		route: T,
		path: String? = nil,
		errorPath: String? = nil,
		retries: Int = 0
	) async throws -> O {
		do {
			let response = try await requestPlain(route: route)
			do {
				return try response.map(type: O.self, nestedAtKeyPath: path)
			} catch {
				var decodedError = try? response.map(type: E.self, nestedAtKeyPath: errorPath)
				decodedError?.response = response.response
				throw decodedError ?? error
			}
		} catch {
			if retries > 0 {
				await handler?.prerequisiteProcessesForRetryRequest(
					for: self,
					route: route,
					error: error
				)
				return try await request(
					type: type,
					route: route,
					path: path,
					errorPath: errorPath,
					retries: retries - 1
				)
			}
			throw error
		}
	}
}

// MARK: - NETWORK CONNECTOR
private extension KSPNetworkProvider {
	/// Perform Moya request.
	func performRequest(route: T) async throws -> Response {
		try await withCheckedThrowingContinuation { continuation in
			provider.request(route) { result in
				switch result {
				case .success(let response):
					continuation.resume(returning: response)
				case .failure(let error):
					continuation.resume(throwing: error)
				}
			}
		}
	}
}
