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
		let data = try JSONSerialization.data(
			withJSONObject: jsonObject,
			options: .prettyPrinted
		)
		return try JSONDecoder().decode(T.self, from: data)
	}
}
