//
//  MediaLibraryAPITarget.swift
//  KyuNetworkExtensions-Client
//

import Foundation
import KyuNetworkExtensions
import Moya

enum MediaLibraryAPITarget {
	case apodByDate(apiKey: String, date: Date)
}

extension MediaLibraryAPITarget: TargetType {
	var baseURL: URL {
		switch self {
		case .apodByDate:
			return URL(string: "https://api.nasa.gov")!
		}
	}
	
	var path: String {
		switch self {
		case .apodByDate:
			return "/planetary/apod"
		}
	}
	
	var headers: [String: String]? {
		return nil
	}
	
	var method: Moya.Method {
		switch self {
		case .apodByDate:
			return .get
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self {
		case .apodByDate(let apiKey, let date):
			let parameters = [
				"api_key": apiKey,
				"date": String(date: date, format: "yyyy-MM-dd")
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
		}
	}
}
