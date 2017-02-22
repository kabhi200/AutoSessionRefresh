//
//  ServiceModel.swift
//  AutomaticSessionRefresh
//

import UIKit


/// Constant Values
let kBaseURLForGetRequest: String = "https://www.google.com"
let kBaseURLForPostRequest: String = "https://www.googleapis.com/books/v1/volumes?q=apple"
let kGETReqType: String = "GET"
let kPOSTReqType: String = "POST"


/// Service Model Protocol
protocol ServiceModelProtocol:class {
    
    func sendDataAfterAutoSessionRefresh(success:Bool, data:Any) -> Void
}

class ServiceModel: NSObject {

    //MARK: - Properties

    var retryCount = 0
    weak var delegate:ServiceModelProtocol?
    let maxSessionRetry = 3

    typealias completionBlock = ((_: Any?, _: Bool) -> Void)
   
    //MARK: - Methods
 
    /// To send post request call for refreshing the session
    func sendPostRequestCallForSessionRefresh() -> Void {
        
        self.sendPostRequest(completionHandler: {
            (data: Any?, _: Bool) -> Void in
            
        })
    }
    
    /// To send Get Request for a given url
    ///
    /// - Parameter completionHandler: completion block object to get data on success and failure.
    func sendGetRequest(completionHandler: @escaping completionBlock)  -> Void {
        
        let requestInstance = self.getRequest(baseURL: kBaseURLForGetRequest, requestType: kGETReqType);
        requestInstance.sendServiceRequest()
        
        requestInstance.success(success: {
            (isSuccess,data) in
            
            // Call parseData method to parse the data and send the Parsed data to the controller.

            completionHandler(data, isSuccess)
        })
        requestInstance.failure(failure: {
            (error, code) in
            
            completionHandler(error, false)
        })
    }

    /// To send Post Request for a given url.
    ///
    /// - Parameter completionHandler: completion block object to get data on success and failure.
    func sendPostRequest(completionHandler: @escaping completionBlock) -> Void {
        
        let requestInstance = self.getRequest(baseURL: kBaseURLForPostRequest, requestType: kPOSTReqType);
        requestInstance.sendServiceRequest()
        
        requestInstance.success(success: {
            (isSuccess,data) in
            
            if(isSuccess)
            {
                if(self.retryCount > 0)
                {

                    // This is called if some response will come with status code 200
                    // Call parseData method to parse the data and send the Parsed data to the controller.
                    self.delegate?.sendDataAfterAutoSessionRefresh(success: isSuccess, data: data as Any)
                }
                else
                {
                    // Call parseData method to parse the data and send the Parsed data to the controller.
                    completionHandler(data, isSuccess)
                }
            }
        })
        
        requestInstance.failure(failure: {
            (error, code) in
            
            if(code != -1)
            {
                if (self.retryCount != self.maxSessionRetry)
                {
                    // To send call to refresh the session so as to retry the same request again to the server after getting failure response
                    self.retryCount += 1
                    self.sendPostRequestCallForSessionRefresh()
                }
                else
                {
                    // After making maximum retries, if the response is still getting failure other than error then this will send error data to the controller.
                    self.delegate?.sendDataAfterAutoSessionRefresh(success: false, data: error)
                }
            }
            else
            {
                // If some error other than data/ response error, then this handler provides the same to the view controller
                completionHandler(error, false)
            }
        })
    }

    /// Common method to get Request
    ///
    /// - Parameters:
    ///   - baseURL: service url
    ///   - requestType: the type of request
    /// - Returns: RequestInstance object
    func getRequest(baseURL: String, requestType:String) -> RequestInstance {
        let requestModel: RequestModel = RequestModel()
        requestModel.type = requestType
        requestModel.url =  baseURL
        return RequestInstance(requestModel: requestModel)
    }
    
//    func parseData(data:Any) -> Any {
//        
//        let ParsedData = data
//        
//        return ParsedData
//    }

}
