//
//  Response.swift
//  Trader
//
//  Created by Subins on 15/01/18.
//  Copyright © 2018 QBurst. All rights reserved.
//

import Foundation
import ObjectMapper

/// Response status
enum ResponseStatus {
	static let success = "SUCCESS"
	static let error = "ERROR"
}

/// Response Error Type
///
/// - noInternetConnection: No internet connection
/// - invaildAuthToken: Invalid authentication token
/// - requestTimedOut: Request timed out
/// - encodingError: Encoding error
/// - serverError: Server error
enum ResponseErrorType {
    case noInternetConnection, invaildAuthToken, requestTimedOut, encodingError, serverError
}

/// Response model
public class Response: Mappable {

    /// Gets or sets the response status
    var status: String?

    /// Gets or sets the response errors
    var errors = [DHError]()

    /// Gets or sets the response message
    var message: String?

    /// Required initializer
    ///
    /// - Parameter map: map data
    required public init?(map: Map) {
    }

    /// Default initializer
    init() {
    }

    /// Mapper function
    ///
    /// - Parameter map: map data
    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["data.message"]
        errors <- map["errors"]
    }

    /// Generate a error Response model for given type
    ///
    /// - Parameter type: ResponseErrorType for error
    /// - Returns: Response model
    class func error(type: ResponseErrorType) -> Response {
        var json: [String : Any] = ["status" : "ERROR"]
        switch type {
        case .noInternetConnection:
            json["errors"] = [["code": ErrorCode.noInternetConnection.rawValue,
                                "message": "No internet connection.".localized]]
        case .invaildAuthToken:
            json["errors"] = [["code": ErrorCode.invalidAccessToken.rawValue,
                              "message": "Invalid Access Token.".localized]]
        case .requestTimedOut:
            json["errors"] = [["code": ErrorCode.requestTimedOut.rawValue,
                              "message": "Request timed out. Please try again".localized]]
        case .encodingError:
            json["errors"] = [["code": ErrorCode.encodingError.rawValue,
                              "message": "Encoding error occured.".localized]]
        case .serverError:
            json["errors"] = [["code": ErrorCode.serverError.rawValue,
                               "message": "SERVER_ERROR_MESSAGE".localized]]
        }
        return Response(JSON: json)!
    }
}
