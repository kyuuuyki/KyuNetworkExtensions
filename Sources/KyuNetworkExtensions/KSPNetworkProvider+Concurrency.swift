//
//  KSPNetworkProvider+Concurrency.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

public extension KSPNetworkProvider {
	class KSPConcurrency {
		private let provider: KSPNetworkProvider
		
		init(provider: KSPNetworkProvider) {
			self.provider = provider
		}
		
		// MARK: PROVIDED PUBLIC FUNCTIONS
		/// Perform request without object mapping.
		public func requestPlain(route: T) async throws -> Response {
			return try await withCheckedThrowingContinuation { continuation in
				provider.requestPlain(route: route) { result in
					switch result {
					case .success(let response):
						continuation.resume(returning: response)
					case .failure(let error):
						continuation.resume(throwing: error)
					}
				}
			}
		}
		
		/// Perform request and map response's data to specific object type.
		public func requestObject<O: Decodable>(
			type: O.Type,
			nestedAt path: String? = nil,
			route: T,
			maxAttempts: Int = 0,
			responseHandler: @escaping (Response) -> Void = { _ in }
		) async throws -> O? {
			return try await withCheckedThrowingContinuation { continuation in
				provider.requestObject(
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts,
					responseHandler: responseHandler
				) { result in
					switch result {
					case .success(let decodable):
						continuation.resume(returning: decodable)
					case .failure(let error):
						continuation.resume(throwing: error)
					}
				}
			}
		}
		
		/// Perform request and map response's data to specific object type in array form.
		public func requestObjects<O: Decodable>(
			type: O.Type,
			nestedAt path: String? = nil,
			route: T,
			maxAttempts: Int = 0,
			responseHandler: @escaping (Response) -> Void = { _ in }
		) async throws -> [O]? {
			return try await withCheckedThrowingContinuation { continuation in
				provider.requestObjects(
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts,
					responseHandler: responseHandler
				) { result in
					switch result {
					case .success(let decodables):
						continuation.resume(returning: decodables)
					case .failure(let error):
						continuation.resume(throwing: error)
					}
				}
			}
		}
	}
	
	var async: KSPConcurrency {
		KSPConcurrency(provider: self)
	}
}
