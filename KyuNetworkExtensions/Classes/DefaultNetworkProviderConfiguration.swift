//
//  DefaultNetworkProviderConfiguration.swift
//  KyuNetworkExtensions
//
//  Created by Chayanon Ardkham on 6/10/20.
//

import Foundation

public protocol DefaultNetworkProviderConfiguration: class {
    func requestPrerequisiteProcesses(completion: @escaping () -> Void)
}

public extension DefaultNetworkProviderConfiguration {
    func requestPrerequisiteProcesses(completion: @escaping () -> Void) {
        completion()
    }
}
