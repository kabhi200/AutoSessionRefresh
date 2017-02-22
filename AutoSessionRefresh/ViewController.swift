//
//  ViewController.swift
//  AutoSessionRefresh
//

import UIKit

class ViewController: UIViewController, ServiceModelProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sendMultipleRequest()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// To send multiple request to ServiceModel class
    func sendMultipleRequest() -> Void {
        
        let serviceModel:ServiceModel = ServiceModel()
        serviceModel.delegate = self
        
        serviceModel.sendGetRequest(completionHandler: {
            (data, isStatus) in
            
            if(isStatus)
            {
                //Show Parsed Data On the View
            }
            else
            {
                // Show Error on a Alert
            }
            
        })
        
        serviceModel.sendPostRequest(completionHandler: {
            (data, isStatus) in
            if(isStatus)
            {
                //Show Parsed Data On the View
            }
            else
            {
                // Show Error on a Alert
            }
        })
    }
    
    /// ServiceModelProtocol method to get response after refreshing of session
    ///
    /// - Parameters:
    ///   - success: Bool value to show success
    ///   - data: Parsed Data in case of success or Error in case of failure
    func sendDataAfterAutoSessionRefresh(success:Bool, data:Any) -> Void
    {
        if(success) {
            //Show Parsed Data On the View
            

        }
        else
        {
            // Show Error on the View
        }
    }

}

