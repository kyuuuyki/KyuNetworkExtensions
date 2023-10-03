//
//  MediaLibraryAPITarget.swift
//  KyuNetworkExtensions-Client
//
//  swiftlint:disable discouraged_optional_collection
//  swiftlint:disable force_unwrapping
//  swiftlint:disable vertical_whitespace_between_cases

import Foundation
import KyuNetworkExtensions
import Moya

enum MediaLibraryAPITarget {
	case apodByDate(date: Date)
	case apodByDateRange(fromDate: Date, toDate: Date)
}

extension MediaLibraryAPITarget: TargetType {
	var baseURL: URL {
		switch self {
		case .apodByDate:
			return URL(string: "https://api.nasa.gov")!
		case .apodByDateRange:
			return URL(string: "https://api.nasa.gov")!
		}
	}
	
	var path: String {
		switch self {
		case .apodByDate:
			return "/planetary/apod"
		case .apodByDateRange:
			return "/planetary/apod"
		}
	}
	
	var headers: [String: String]? {
		nil
	}
	
	var method: Moya.Method {
		switch self {
		case .apodByDate:
			return .get
		case .apodByDateRange:
			return .get
		}
	}
	
	var sampleData: Data {
		Data()
	}
	
	var task: Task {
		switch self {
		case .apodByDate(let date):
			let parameters = [
				"api_key": sharedAPIKey,
				"date": String(date: date, format: "yyyy-MM-dd")
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
		case .apodByDateRange(let fromDate, let toDate):
			let parameters = [
				"api_key": sharedAPIKey,
				"start_date": String(date: fromDate, format: "yyyy-MM-dd"),
				"end_date": String(date: toDate, format: "yyyy-MM-dd")
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
		}
	}
}
