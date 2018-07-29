//
//  WebService.swift
//  Alamofire
//
//  Created by Akhilraj on 05/10/17.
//

import Foundation
import Alamofire
import ObjectMapper
import KeychainAccess

/// Diffrerent error codes
///
/// - noInternetConnection: error for no internet connection
/// - invalidAccessToken: error for invalid access token
/// - requestTimedOut: error for request time out
/// - incorrectOTP: error for incorrect OTP
/// - socialUserNotExist: error for no social user exist
/// - encodingError: error for encoding error
/// - serverError: server error
enum ErrorCode: String {
    case noInternetConnection = "400"
    case invalidAccessToken = "1100"
    case requestTimedOut = "1001"
    case incorrectOTP = "1028"
    case socialUserNotExist = "1053"
    case encodingError = "5"
    case serverError = "500"
}

/// Dhowber webservice
public class WebService {
    private var alamofireManager = Alamofire.SessionManager.default

    /// Create a webservice request for given type.
    ///
    /// - Parameters:
    ///   - type: request type as RequestTypeProtocol
    ///   - completion: response as Response model
    func request(type: RequestTypeProtocol,
                 completion: @escaping (_ response: Response) -> Void ) {
        if NetworkReachabilityManager()!.isReachable {
            alamofireManager.session.configuration.timeoutIntervalForRequest = 10 //10 secs
            let method = type.getHTTPMethod()
            let requestURL = URL(string: getURLString(type))!
            debugPrint(requestURL)
            let parameters = type.params()
            debugPrint(parameters ?? "No Parameters")
            let header = getRequestHeader(for: type)
            let encoding: ParameterEncoding = (method == .get
                || method == .delete ? URLEncoding.default : JSONEncoding.default)
            let request = alamofireManager.request(requestURL,
                                                   method: method,
                                                   parameters: parameters,
                                                   encoding: encoding,
                                                   headers: header)
            request.responseData(completionHandler: { response in
                self.validateResponse(response,
                                      type: type,
                                      completion)
            })
        } else {
            completion(Response.error(type: .noInternetConnection))
        }
    }

    /// Validate the webservice response and generate a Response model obeject.
    ///
    /// - Parameters:
    ///   - response: DataResponse
    ///   - type: request type conforming RequestTypeProtocol
    ///   - callback: Response model object with success/error details
    func validateResponse(_ response: DataResponse<Data>,
                          type: RequestTypeProtocol,
                          _ callback: @escaping (_ response: Response) -> Void) {
        switch response.result {
        case .success(let data):
            if let responseJSON = try? JSONSerialization
                .jsonObject(with: data, options: []) as? [String : Any] {
                debugPrint(responseJSON ?? "Error Parsing JSON")

                if let model = type.responseModel(responseJSON!) {
                    if model.errors.first?.code == ErrorCode.invalidAccessToken.rawValue {
                        //TODO: Update Token
                    } else {
                        callback(model)
                    }
                }
            } else {
//                debugPrint("Request failed")
                callback(Response.error(type: .serverError))
            }
        case .failure(let error):
            debugPrint("Request failed with error: \(error)")
            callback(Response.error(type: .serverError))
        }
    }

    /// Cancell all webservice requests
    public func cancelAllRequests() {
        alamofireManager.session.getAllTasks { (dataTask) in
            dataTask.forEach { $0.cancel() }
        }
    }

    /// Generate a request header with Language and Authentication details
    ///
    /// - Parameter type: request type conforming RequestTypeProtocol
    /// - Returns: header details as HTTPHeaders
    func getRequestHeader(for type: RequestTypeProtocol) -> HTTPHeaders {
        let header = ["Language-preference" : "Language".localized]
        //TODO: Add service name and token
        if type.isAuthRequired() {
//            header["Authorization"] = "Bearer \(token)"
        }
        return header
    }
    
    /// Validate upload service response
    ///
    /// - Parameters:
    ///   - response: DataResponse
    ///   - type: request type conforming RequestTypeProtocol
    ///   - completion: Response model object with success/error details
    func validateUploadResonse(_ response: DataResponse<Any>,
                               type: RequestTypeProtocol,
                               completion: @escaping (_ response: Response) -> Void) {
        switch response.result {
        case .success:
            if let responseJSON = try? JSONSerialization
                .jsonObject(with: response.data!,
                            options: []) as? [String : Any] {
                if let model = type.responseModel(responseJSON!) {
                    if model.errors.first?.code == ErrorCode.invalidAccessToken.rawValue {
                        //TODO: Token renew
                    } else {
                        completion(model)
                    }
                }
            }
        case .failure(let error):
            debugPrint("Request failed with error: \(error)")
            completion(Response.error(type: .requestTimedOut))
        }
    }

    /// Generate request URL with base URL and type. If the environment is DEBUG, get the base URL from
    /// Constants.baseURL. Else get the base URL from info.plist
    ///
    /// - Parameters:
    ///   - baseURL: Base URL as string
    ///   - type: request type conforming RequestTypeProtocol
    /// - Returns: Request URL as String
    func getURLString(_ type: RequestTypeProtocol) -> String {
        let urlString =  getBaseURLfrom() + type.getRequestUrl()
        return urlString
    }

    /// Get base URL
    ///
    /// - Returns: URL string
    func getBaseURLfrom() -> String {
        if let baseURL = UserDefaults.standard.string(forKey: "server_URL") {
            return baseURL
        } else {
            return Constants.baseURL
        }
    }

    func upload(type: RequestTypeProtocol,
                fileURL: URL,
                completion: @escaping (_ response: Response) -> Void ) {
        if NetworkReachabilityManager()!.isReachable {
                let requestURL = URL(string: getURLString(type))!
                let header = getRequestHeader(for: type)

                alamofireManager.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(fileURL, withName: "file")
                    if fileURL.pathExtension == "mp4" {
                        if let data = "application/mp4".data(using: .utf8) {
                            multipartFormData.append(data, withName: "mime_type")
                        }

                        if let data = "true".data(using: .utf8) {
                            multipartFormData.append(data, withName: "is_video")
                        }
                    } else {
                        if let data = "application/jpg".data(using: .utf8) {
                            multipartFormData.append(data, withName: "mime_type")
                        }

                        if let data = "false".data(using: .utf8) {
                            multipartFormData.append(data, withName: "is_video")
                        }
                    }

                    if let cargoData = "cargo".data(using: .utf8) {
                        multipartFormData.append(cargoData, withName: "entity_type")
                    }
                }, to: requestURL,
                   headers: header,
                   encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })

                        upload.responseJSON { response in
                            self.validateUploadResonse(response,
                                                       type: type,
                                                       completion: completion)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        completion(Response.error(type: .encodingError))
                    }
                })
        } else {
            completion(Response.error(type: .noInternetConnection))
        }
    }
}
