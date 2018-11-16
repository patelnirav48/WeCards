//
//  WCWebServiceModal.swift
//  Patel-Apps Pvt Ltd
//
//  Created by Nirav on 12/19/16.
//  Copyright © 2016 Patel-Apps Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire


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
        
        Alamofire.request(request).responseJSON { response in
            
            if (ref is UIViewController) && (ref as! UIViewController).navigationController?.view.isUserInteractionEnabled == false {
                (ref as! UIViewController).navigationController?.view.isUserInteractionEnabled = true
            }
            
            switch response.result {
                
            case .success:
                
                let aDictResponse = try! JSONSerialization.jsonObject(with: response.data!) as! NSDictionary
                
                //AppDelegate().getInstance().log(message: "Response Data: \(aDictResponse)")
                
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
                
                
            case .failure(let error):
                
                let aStrMessageTag = "MSG_NO_INTERNET"
                if error._code != -999 {
                    
                    UIViewController.presentAlert(title: "", message: "\(error.localizedDescription)", options: "LBL_OK") { (option) in
                    }
                }
                
                //AppDelegate().getInstance().log(message: "Response Failed Message: \(error.localizedDescription)")
                
                do
                {
                    let aDicResult = ["status" : "fail", "message" : error.localizedDescription]
                    //AppDelegate().getInstance().log(message: "\(["result" : aDicResult])")
                    
                    try ref.getWebserviceResponse(aDictResponse: ["result" : aDicResult], aStrTag: aStrMessageTag)
                }
                catch
                {
                    //AppDelegate().getInstance().log(message: "Error")
                }
            }
            
        }
        
    }
    
    func methodsToCancelAllRequest() {
        
        if #available(iOS 9.0, *) {
            
            Alamofire.SessionManager.default.session.getAllTasks(completionHandler: { (task) in
                task.forEach({$0.cancel()})
            })
            
        } else {
            
            // Fallback on earlier versions
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
        }
    }
    
}

