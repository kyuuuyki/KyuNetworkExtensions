//
//  KSPNetworkProvider.swift
//  KyuNetworkExtensions
//
//  swiftlint:disable line_length
//  swiftlint:disable vertical_whitespace_between_cases

import Foundation
import Moya

// MARK: - CLASS
public struct KSPNetworkProvider<T: TargetType, E: KSPNetworkErrorProtocol> {
	// MARK: MODEL
	public var provider: MoyaProvider<T>
	public weak var handler: KSPNetworkHandler?
	
	// MARK: INITIALIZATION
	public init(
		endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
		requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
		stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider<T>.neverStub,
		callbackQueue: DispatchQueue? = nil,
		session: Session = MoyaProvider<T>.defaultAlamofireSession(),
		plugins: [PluginType] = [],
		trackInflights: Bool = false
	) {
		self.provider = MoyaProvider<T>(
			endpointClosure: endpointClosure,
			requestClosure: requestClosure,
			stubClosure: stubClosure,
			callbackQueue: callbackQueue,
			session: session,
			plugins: plugins,
			trackInflights: trackInflights
		)
	}
	
	// MARK: PROVIDED PUBLIC FUNCTIONS
	/// Perform request without object mapping.
	public func requestPlain(route: T) async throws -> Response {
		await handler?.prerequisiteProcessesForRequest(for: self, route: route)
		return try await performRequest(route: route)
	}
	
	/// Perform request and map response's data to specific object type.
	public func requestObject<O: Decodable>(
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
				throw (try? response.map(type: E.self, nestedAtKeyPath: errorPath)) ?? error
			}
		} catch {
			if retries > 0 {
				await handler?.prerequisiteProcessesForRetryRequest(
					for: self,
					route: route,
					error: error
				)
				return try await requestObject(
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
	
	/// Perform request and map response's data to specific object type in array form.
	public func requestObjects<O: Decodable>(
		type: O.Type,
		route: T,
		path: String? = nil,
		errorPath: String? = nil,
		retries: Int = 0
	) async throws -> [O] {
		do {
			let response = try await requestPlain(route: route)
			do {
				return try response.mapArray(type: O.self, nestedAtKeyPath: path)
			} catch {
				throw (try? response.map(type: E.self, nestedAtKeyPath: errorPath)) ?? error
			}
		} catch {
			if retries > 0 {
				await handler?.prerequisiteProcessesForRetryRequest(
					for: self,
					route: route,
					error: error
				)
				return try await requestObjects(
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
