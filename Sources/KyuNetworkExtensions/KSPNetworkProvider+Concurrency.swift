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
		public func requestPlain(route: T) async -> (Result<Response, E>) {
			return await withCheckedContinuation { continuation in
				provider.requestPlain(route: route) { result in
					continuation.resume(returning: result)
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
		) async -> (Result<O?, E>) {
			return await withCheckedContinuation { continuation in
				provider.requestObject(
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts,
					responseHandler: responseHandler
				) { result in
					continuation.resume(returning: result)
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
		) async -> (Result<[O]?, E>) {
			return await withCheckedContinuation { continuation in
				provider.requestObjects(
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts,
					responseHandler: responseHandler
				) { result in
					continuation.resume(returning: result)
				}
			}
		}
	}
	
	var async: KSPConcurrency {
		KSPConcurrency(provider: self)
	}
}
