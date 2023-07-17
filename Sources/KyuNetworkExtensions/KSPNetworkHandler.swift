//
//  KSPNetworkHandler.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

// MARK: - DATASOURCE
public protocol KSPNetworkHandler: AnyObject {
	/// User-defined processes before perform any request.
	func prerequisiteProcessesForRequest<T: TargetType, U: KSPNetworkErrorProtocol>(
		for provider: KSPNetworkProvider<T, U>,
		performRequest: @escaping () -> Void
	)
	/// User-defined processes before retry any request.
	func prerequisiteProcessesForRetryRequest<T: TargetType, U: KSPNetworkErrorProtocol>(
		for provider: KSPNetworkProvider<T, U>,
		previousError error: U,
		performRetryRequest: @escaping () -> Void
	)
}

// MARK: - DEFAULT DATASOURCE
public extension KSPNetworkHandler {
	func prerequisiteProcessesForRequest<T: TargetType, U: KSPNetworkErrorProtocol>(
		for provider: KSPNetworkProvider<T, U>,
		performRequest: @escaping () -> Void
	) { performRequest() }
	func prerequisiteProcessesForRetryRequest<T: TargetType, U: KSPNetworkErrorProtocol>(
		for provider: KSPNetworkProvider<T, U>,
		previousError error: U,
		performRetryRequest: @escaping () -> Void
	) {
		performRetryRequest()
	}
}
