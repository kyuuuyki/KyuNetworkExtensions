//
//  KSPNetworkProvider.swift
//  KyuNetworkExtensions
//

//  swiftlint:disable function_parameter_count line_length

import Foundation
import Moya

// MARK: - CLASS
public struct KSPNetworkProvider<T: TargetType, E: KSPNetworkErrorProtocol> {
	// MARK: MODEL
	public var provider: MoyaProvider<T>!
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
	public func requestPlain(route: T, completion: @escaping (Result<Response, E>) -> Void) {
		if let handler = handler {
			handler.prerequisiteProcessesForRequest(for: self) {
				self.performRequest(route: route, completion: completion)
			}
		} else {
			self.performRequest(route: route, completion: completion)
		}
	}
	
	/// Perform request and map response's data to specific object type.
	public func requestObject<O: Decodable>(
		type: O.Type,
		nestedAt path: String? = nil,
		route: T,
		maxAttempts: Int = 0,
		responseHandler: @escaping (Response) -> Void = { _ in },
		completion: @escaping (Result<O?, E>) -> Void
	) {
		request(
			isRequestingArrayOfObjects: false,
			type: type,
			nestedAt: path,
			route: route,
			maxAttempts: maxAttempts,
			responseHandler: responseHandler
		) { result in
			switch result {
			case .success(let object):
				completion(.success(object as? O))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	/// Perform request and map response's data to specific object type in array form.
	public func requestObjects<O: Decodable>(
		type: O.Type,
		nestedAt path: String? = nil,
		route: T,
		maxAttempts: Int = 0,
		responseHandler: @escaping (Response) -> Void = { _ in },
		completion: @escaping (Result<[O]?, E>) -> Void
	) {
		request(
			isRequestingArrayOfObjects: true,
			type: type,
			nestedAt: path,
			route: route,
			maxAttempts: maxAttempts,
			responseHandler: responseHandler
		) { result in
			switch result {
			case .success(let objects):
				completion(.success(objects as? [O]))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}

// MARK: - NETWORK CONNECTOR
private extension KSPNetworkProvider {
	/// Perform request and auto-map to specific object type.
	func request<O: Decodable>(
		isRequestingArrayOfObjects: Bool,
		type: O.Type,
		nestedAt path: String?,
		route: T,
		maxAttempts: Int,
		responseHandler: @escaping (Response) -> Void,
		completion: @escaping (Result<Any, E>) -> Void
	) {
		requestPlain(route: route) { result in
			switch result {
			case .success(let response):
				if let serializedObject = try? response.map(type: O.self, nestedAt: path) {
					responseHandler(response)
					completion(.success(serializedObject))
					return
				} else if isRequestingArrayOfObjects,
						  let serializedObjects = try? response.mapArray(type: O.self, nestedAt: path) {
					responseHandler(response)
					completion(.success(serializedObjects))
					return
				}
				self.requestErrorHandling(
					error: E(response: response),
					isRequestingArrayOfObjects: isRequestingArrayOfObjects,
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts - 1,
					responseHandler: responseHandler,
					completion: completion
				)
				
			case .failure(let error):
				self.requestErrorHandling(
					error: error,
					isRequestingArrayOfObjects: isRequestingArrayOfObjects,
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts - 1,
					responseHandler: responseHandler,
					completion: completion
				)
			}
		}
	}
	
	/// Perform Moya request.
	func performRequest(route: T, completion: @escaping (Result<Response, E>) -> Void) {
		self.provider.request(route) { result in
			switch result {
			case .success(let response):
				if (200..<300).contains(response.statusCode) {
					completion(.success(response))
				} else {
					if var error = try? response.map(type: E.self) {
						error.statusCode = response.statusCode
						completion(.failure(error))
					} else {
						completion(.failure(E(response: response)))
					}
				}
			case .failure(let moyaError):
				completion(.failure(E(moyaError: moyaError)))
			}
		}
	}
	
	/// Request error handling.
	func requestErrorHandling<O: Decodable>(
		error: E,
		isRequestingArrayOfObjects: Bool,
		type: O.Type,
		nestedAt path: String?,
		route: T,
		maxAttempts: Int,
		responseHandler: @escaping (Response) -> Void,
		completion: @escaping (Result<Any, E>) -> Void
	) {
		if maxAttempts >= 0 {
			if let handler = self.handler {
				handler.prerequisiteProcessesForRetryRequest(for: self, previousError: error) {
					self.request(
						isRequestingArrayOfObjects: isRequestingArrayOfObjects,
						type: type,
						nestedAt: path,
						route: route,
						maxAttempts: maxAttempts,
						responseHandler: responseHandler,
						completion: completion
					)
				}
			} else {
				self.request(
					isRequestingArrayOfObjects: isRequestingArrayOfObjects,
					type: type,
					nestedAt: path,
					route: route,
					maxAttempts: maxAttempts,
					responseHandler: responseHandler,
					completion: completion
				)
			}
		} else {
			completion(.failure(error))
		}
	}
}
