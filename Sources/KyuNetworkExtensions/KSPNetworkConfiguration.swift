//
//  KSPNetworkConfiguration.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

// MARK: - CLASS
public struct KSPNetworkConfiguration {
	// MARK: MODEL
	public let stubBehavior: StubBehavior
	public let plugins: [PluginType]
	
	// MARK: INITIALIZATION
	public init(
		stubBehavior: StubBehavior = .never,
		plugins: [PluginType] = [PluginType]()
	) {
		self.stubBehavior = stubBehavior
		self.plugins = plugins
	}
}
