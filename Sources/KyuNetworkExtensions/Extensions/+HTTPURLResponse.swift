//  swiftlint:disable:this file_name
//
//  +HTTPURLResponse.swift
//  KyuNetworkExtensions
//
//  swiftlint:disable line_length
//  swiftlint:disable no_magic_numbers
//  swiftlint:disable vertical_whitespace_between_cases

import Foundation

/// HTTP status codes from [Internet Engineering Task Force's RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110#name-status-codes)
public extension HTTPURLResponse {
	enum StatusCodeType: Int {
		case `continue` = 100
		case switchingProtocols = 101
		case processing = 102
		case earlyHints = 103
		
		case ok = 200 // swiftlint:disable:this identifier_name
		case created = 201
		case accepted = 202
		case nonAuthoritativeInformation = 203
		case noContent = 204
		case resetContent = 205
		case partialContent = 206
		case multiStatus = 207
		case alreadyReported = 208
		case imUsed = 226
		
		case multipleChoices = 300
		case movedPermanently = 301
		case found = 302
		case seeOther = 303
		case notModified = 304
		case useProxy = 305
		case temporaryRedirect = 307
		case permanentRedirect = 308
		
		case badRequest = 400
		case unauthorized = 401
		case paymentRequired = 402
		case forbidden = 403
		case notFound = 404
		case methodNotAllowed = 405
		case notAcceptable = 406
		case proxyAuthenticationRequired = 407
		case requestTimeout = 408
		case conflict = 409
		case gone = 410
		case lengthRequired = 411
		case preconditionFailed = 412
		case payloadTooLarge = 413
		case uriTooLong = 414
		case unsupportedMediaType = 415
		case rangeNotSatisfiable = 416
		case expectationFailed = 417
		case misdirectedRequest = 421
		case unprocessableEntity = 422
		case locked = 423
		case failedDependency = 424
		case tooEarly = 425
		case upgradeRequired = 426
		case preconditionRequired = 428
		case tooManyRequests = 429
		case requestHeaderFieldsTooLarge = 431
		case unavailableForLegalReasons = 451
		
		case internalServerError = 500
		case notImplemented = 501
		case badGateway = 502
		case serviceUnavailable = 503
		case gatewayTimeout = 504
		case httpVersionNotSupported = 505
		case variantAlsoNegotiates = 506
		case insufficientStorage = 507
		case loopDetected = 508
		case notExtended = 510
		case networkAuthenticationRequired = 511
	}
	
	var status: StatusCodeType? {
		StatusCodeType(rawValue: statusCode)
	}
}

public extension HTTPURLResponse {
	enum StatusClassType {
		case informational
		case success
		case redirection
		case clientError
		case serverError
		case undefined
	}
	
	var statusClass: StatusClassType {
		switch statusCode {
		case 100..<200:
			return .informational
		case 200..<300:
			return .success
		case 300..<400:
			return .redirection
		case 400..<500:
			return .clientError
		case 500..<600:
			return .serverError
		default:
			return .undefined
		}
	}
}
