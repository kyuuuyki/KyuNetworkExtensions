//  swiftlint:disable:this file_name
//
//  +Response.swift
//  KyuNetworkExtensions
//

import Foundation
import Moya

public extension Response {
	/// JSONObject from JSONData.
	func map<T: Decodable>(type: T.Type, nestedAtKeyPath keyPath: String? = nil) throws -> T {
		try JSONDecoder().decode(T.self, from: try nestedValue(atKeyPath: keyPath))
	}
	
	/// JSONObjects from JSONData.
	func mapArray<T: Decodable>(type: T.Type, nestedAtKeyPath keyPath: String? = nil) throws -> [T] {
		try JSONDecoder().decode([T].self, from: try nestedValue(atKeyPath: keyPath))
	}
	
	/// Get Nested Value at specific keyPath.
	func nestedValue(atKeyPath keyPath: String?) throws -> Data {
		var jsonObject = try JSONSerialization.jsonObject(
			with: data,
			options: .allowFragments
		) as AnyObject
		if let keyPath {
			jsonObject = jsonObject.value(forKeyPath: keyPath) as AnyObject
		}
		if jsonObject is NSNull {
			jsonObject = [:] as AnyObject
		}
		return try JSONSerialization.data(
			withJSONObject: jsonObject,
			options: .prettyPrinted
		)
	}
}
