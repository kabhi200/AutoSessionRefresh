//
//  RequestInstance.swift
//  AutomaticSessionRefresh
//

import UIKit

class RequestInstance: NSObject {
    
    var requestModel: RequestModel = RequestModel()
    
    init(requestModel: RequestModel) {
        super.init()
        self.requestModel = requestModel
    }
    
    
    /// This method will be called when a successful response will come after sending request to the server.
    ///
    /// - Parameter success: The success parameters
    func success(success: @escaping (_ isSuccess: Bool, _ data: AnyObject?) -> Void) -> Void {
        self.requestModel.success = success
    }
    
    
    /// This method will be called when a failure response will come after sending request to the server.
    ///
    /// - Parameter failure: Failure parameters containing the error and error code
    func failure(failure: @escaping (_ error: String, _ code: NSInteger) -> Void) -> Void {
        self.requestModel.failure = failure
    }
    
    
    /// Common method to send service request.
    func sendServiceRequest() -> Void {
        NetworkRequest.sharedInstance.serviceWithRequestModel(requestModel: self.requestModel)
        
    }
    
}
