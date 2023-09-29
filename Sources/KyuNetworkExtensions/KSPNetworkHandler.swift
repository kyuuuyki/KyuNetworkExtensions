//
//  KSPNetworkHandler.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

// MARK: - DATASOURCE
public protocol KSPNetworkHandler: AnyObject {
	/// User-defined processes before perform any request.
	func prerequisiteProcessesForRequest<T: TargetType, E: DecodableError>(
		for provider: KSPNetworkProvider<T, E>,
		route: T
	) async
	/// User-defined processes before retry any request.
	func prerequisiteProcessesForRetryRequest<T: TargetType, E: DecodableError>(
		for provider: KSPNetworkProvider<T, E>,
		route: T,
		error: Error
	) async
}
