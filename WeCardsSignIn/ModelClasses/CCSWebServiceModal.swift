//
//  WCWebServiceModal.swift
//  Patel-Apps Pvt Ltd
//
//  Created by Nirav on 12/19/16.
//  Copyright © 2016 Patel-Apps Pvt Ltd. All rights reserved.
//

import UIKit

protocol WebServiceDelegate
{
    func getWebserviceResponse(aDictResponse: NSDictionary, aStrTag: String) throws
}

class CCSWebServiceModal: NSObject
{
    var reachability = Reachability()
    
    func checkNetworkStatus() -> Bool {
        
        var isAvailable = Bool()
        
        if reachability?.connection.description == "No Connection" {
            isAvailable = false
        }
        else {
            isAvailable = true
        }
        
        return isAvailable
    }
    
    func callWebservice(aStrUrl:String, aMutDictParams:NSMutableDictionary, ref: WebServiceDelegate, aStrTag:String)
    {
        if !checkNetworkStatus() {
            
            DispatchQueue.global(qos: .default).async{
                
                DispatchQueue.main.async {
                    
                    //AppDelegate().getInstance().log(message: NSLocalizedString("MSG_NO_INTERNET", comment: ""))
                    
                    UIViewController.presentAlert(title: "", message: "MSG_NO_INTERNET", options: "LBL_OK") { (option) in
                    }
                    
                    do {
                        try ref.getWebserviceResponse(aDictResponse: NSMutableDictionary.init(), aStrTag: NSLocalizedString("MSG_NO_INTERNET", comment: ""))
                    }
                    catch {
                        //AppDelegate().getInstance().log(message: "Error")
                    }
                }
            }
            
            return
        }
        
        
        DispatchQueue.main.async {
            
            if ref is UIViewController {
                (ref as! UIViewController).navigationController?.view.isUserInteractionEnabled = false
            }
        }
        
        let aStrFinalUrl = "\(Constant.structCommanUrl.kCommanUrl)\(aStrUrl)"
        //AppDelegate().getInstance().log(message: "API URL: \(aStrFinalUrl)")
        
        var request = URLRequest(url: URL(string: aStrFinalUrl)!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: aMutDictParams)
        
        /*let aStrJsonParams = try! JSONSerialization.data(withJSONObject: aMutDictParams)
        //AppDelegate().getInstance().log(message: "\(String(data: aStrJsonParams,encoding: .ascii)!)")
        
        let aStrParams = NSString(data: aStrJsonParams, encoding: String.Encoding.utf8.rawValue)
        
        request.allHTTPHeaderFields = ["x-hash": (HMAC.sign(message: (aStrParams! as String), algorithm: .md5, key: Constant.structApi.kAPISecret))!,
                                       "x-api-key": Constant.structApi.kAPIKey]
        
        //AppDelegate().getInstance().log(message: "\(request.allHTTPHeaderFields!)")*/

        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) -> Void in
            
            if (ref is UIViewController) && (ref as! UIViewController).navigationController?.view.isUserInteractionEnabled == false {
                (ref as! UIViewController).navigationController?.view.isUserInteractionEnabled = true
            }
            
            let aDictResponse: NSDictionary! = try! JSONSerialization.jsonObject(with: data) as? NSDictionary
            
            DispatchQueue.main.async {
                
                if aDictResponse != nil {
                    
                    //Display Success/Fail message of webservice
                    if ((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "status") as! String) == "fail" {
                        
                        if (aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "data") is NSDictionary
                        {
                            if !(((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSDictionary).allKeys as NSArray).contains("alert")
                            {
                                UIViewController.presentAlert(title: "", message: (aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "message") as? String ?? "", options: "LBL_OK") { (option) in
                                }
                            }
                        }
                        else {
                            
                            UIViewController.presentAlert(title: "", message: (aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "message") as? String ?? "", options: "LBL_OK") { (option) in
                            }
                        }
                        
                    }
                    else {
                        
                        if ((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "message") as! String) != "" {
                            
                            UIViewController.presentAlert(title: "", message: (aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "message") as? String ?? "", options: "LBL_OK") { (option) in
                            }
                        }
                    }
                    
                    do
                    {
                        if ((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "message") as! String) == "Invalid Token."
                        {
                            UIViewController.presentAlert(title: "", message: "MSG_LOGINOTHERDEVICE", options: "LBL_OK") { (option) in
                            }
                        }
                        else
                        {
                            try ref.getWebserviceResponse(aDictResponse: aDictResponse, aStrTag: aStrTag)
                        }
                    }
                    catch
                    {
                        //AppDelegate().getInstance().log(message: "Error")
                    }
                    
                }
                else {
                    
                    do
                    {
                        
                        let aStrMessageTag = "MSG_NO_INTERNET"
                        
                        let aDicResult = ["status" : "fail", "message" : error.localizedDescription]
                        try ref.getWebserviceResponse(aDictResponse: ["result" : aDicResult], aStrTag: aStrMessageTag)
                    }
                    catch {
                    }
                    
                }
            }
        })
        
    }
    
}

