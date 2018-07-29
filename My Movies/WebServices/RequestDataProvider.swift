//
//  RequestDataProvider.swift
//  RedmineRestSDK
//
//  Created by Akhilraj on 05/10/17.
//

import Foundation
import Alamofire

/// Request Type Protocol
public protocol RequestTypeProtocol {

    /// Get the data provider for a request
    ///
    /// - Returns: RequestDataProviderProtocol
    func getDataProvider() -> RequestDataProviderProtocol

    /// Get request type
    ///
    /// - Returns: HTTPMethod
    func getHTTPMethod() -> HTTPMethod

    /// Get request URL
    ///
    /// - Returns: URL string
    func getRequestUrl() -> String

    /// Get authentication required status
    ///
    /// - Returns: Bool
    func isAuthRequired() -> Bool

    /// Get request parameters
    ///
    /// - Returns: [String : Any]
    func params() -> [String: Any]?

    /// Response model for the request
    ///
    /// - Parameter json: JSON data
    /// - Returns: Model
    func responseModel(_ json: [String : Any]) -> Response?
}

extension RequestTypeProtocol {
    public func getHTTPMethod() -> HTTPMethod {
        return getDataProvider().requestMethodForType(self)
    }

    public func getRequestUrl() -> String {
        return getDataProvider().requestUrlForType(self)
    }

    public func isAuthRequired() -> Bool {
        return getDataProvider().requireAuthForType(self)
    }

    public func params() -> [String: Any]? {
        return getDataProvider().requestParamsForType(self)
    }

    public func responseModel(_ response: [String : Any]) -> Response? {
        return getDataProvider().responseModel(self,
                                               response: response)
    }
}

public protocol RequestDataProviderProtocol {
    func requireAuthForType(_ type: RequestTypeProtocol) -> Bool
    func requestMethodForType(_ type: RequestTypeProtocol) -> HTTPMethod
    func requestUrlForType(_ type: RequestTypeProtocol) -> String
    func requestParamsForType(_ type: RequestTypeProtocol) -> [String: Any]?
    func responseModel(_ type: RequestTypeProtocol,
                       response: [String : Any]) -> Response?
}

class RequestDataProvider {
    static let responseFormat = "json"
}
