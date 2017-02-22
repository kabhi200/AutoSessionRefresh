//
//  NetworkRequest.swift
//  AutomaticSessionRefresh
//

import UIKit

/// Constant Values

let kKeyContentType: String = "Content-Type"
let kValueApplicationJSON: String = "application/json"

let kKeyAccessToken: String = "Authorization"
let kValueAccessToken: String = "ValidAccessToken"

let kServerError: String = "Server Error"
let kNoResponse: String = "No Response"
let kNoConnection: String = "Could Not Connect"
let kNoValidResponse: String = "Could not get a valid response from server"


class NetworkRequest: NSObject {
    //MARK: - Properties
    
    static let sharedInstance = NetworkRequest()
    private let opQueue = OperationQueue()

    private var session: URLSession?
    private var configuration: URLSessionConfiguration?
    private var requestModel: RequestModel = RequestModel()

    //MARK: - Methods

    /// Overriding Init Method
    override init() {
        self.configuration = URLSessionConfiguration.default
        self.configuration?.timeoutIntervalForRequest = 60
        self.configuration?.requestCachePolicy = .useProtocolCachePolicy
        self.session = URLSession(configuration: self.configuration!)
    }
    
    
    /// To create request for a url
    ///
    /// - Parameters:
    ///   - path: The url path
    ///   - reqModel: the RequestModel object containing the request information.
    /// - Returns: the URLRequest object
    private func createRequest(with path:String, reqModel:RequestModel) -> URLRequest {
        
        let url = URL(string: path)
        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = reqModel.type

        if (reqModel.type == "POST") {
            request.setValue(kValueApplicationJSON, forHTTPHeaderField: kKeyContentType)
            request.addValue(kValueAccessToken, forHTTPHeaderField: kKeyAccessToken)
        }
        return request;
    }

    /// Common service method for sending request to the server.
    ///
    /// - Parameter requestModel: RequestModel object containing the request information.
    func serviceWithRequestModel(requestModel: RequestModel) -> Void {
        
        let reqModel = requestModel
        let request = self.createRequest(with: reqModel.url!, reqModel: reqModel)

        let newOperation : BlockOperation = BlockOperation {
         
            let dataTask: URLSessionDataTask? = self.session?.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil {
                    reqModel.failure!(kServerError, -1)
                }
                if response == nil {
                    reqModel.failure!(kNoResponse, -1)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        reqModel.failure!(kNoConnection, httpResponse.statusCode)
                    }
                    else {
                        //Success
                        guard data != nil
                            else {
                                reqModel.failure!(kNoValidResponse, -1)
                                return
                        }
                        reqModel.success!(true, data as AnyObject?)
                    }
                }
                else {
                    reqModel.failure!(kServerError, -1)
                }
            })
            
            dataTask?.resume()
        }
        self.opQueue.addOperation(newOperation);
    }
}
