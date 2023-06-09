//
//  MediaLibraryAPODItemProtocol.swift
//  KyuNetworkExtensions-Client
//

import Foundation

public protocol MediaLibraryAPODItemProtocol {
	var date: Date { get }
	var title: String { get }
	var description: String? { get }
	var imageUrl: URL { get }
	var imageHDUrl: URL? { get }
	var link: URL? { get }
}
