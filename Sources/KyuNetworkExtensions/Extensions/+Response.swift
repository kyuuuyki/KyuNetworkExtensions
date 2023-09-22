//  swiftlint:disable:this file_name
//
//  +Response.swift
//  KyuNetworkExtensions
//

import Foundation
import KyuGenericExtensions
import Moya

public extension Response {
	/// JSONObject from JSONData.
	func map<T: Decodable>(type: T.Type, nestedAt path: String? = nil) throws -> T {
		do {
			return try JSONDecoder().decode(T.self, from: try nestedValue(at: path))
		} catch {
			throw MoyaError.jsonMapping(self)
		}
	}
	
	/// JSONObjects from JSONData.
	func mapArray<T: Decodable>(type: T.Type, nestedAt path: String? = nil) throws -> [T] {
		do {
			return try JSONDecoder().decode([T].self, from: try nestedValue(at: path))
		} catch {
			throw MoyaError.jsonMapping(self)
		}
	}
	
	/// Get Nested Value at specific path separated by ".".
	func nestedValue(at path: String?) throws -> Data {
		do {
			var jsonObject = try JSONSerialization.jsonObject(
				with: data,
				options: .allowFragments
			) as AnyObject
			if let path {
				let nestedKeys = path.components(separatedBy: ".")
				for nestedKey in nestedKeys {
					guard let nestedObject = jsonObject.value(forKeyPath: nestedKey) else {
						throw MoyaError.jsonMapping(self)
					}
					jsonObject = nestedObject as AnyObject
				}
			}
			return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
		} catch {
			throw MoyaError.jsonMapping(self)
		}
	}
}
