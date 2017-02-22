//
//  RequestModel.swift
//  AutomaticSessionRefresh
//

import UIKit

// Request Model class to set the request data.
class RequestModel: NSObject {

    var type: String = "GET"
    var url: String?
    var success: ((_ success: Bool, _ data: AnyObject?) -> Void)?
    var failure: ((_ error: String, _ code: NSInteger) -> Void)?
}
