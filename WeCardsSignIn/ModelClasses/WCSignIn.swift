//
//  WCSignIn.swift
//  WeCardsSignIn-Example
//
//  Created by Nirav Patel on 28-09-18.
//  Copyright © 2018 Nirav Patel. All rights reserved.
//

import UIKit

public protocol WeCardsSignInDelegate
{
    func onAuthenticationSuccessful(dictionary: NSDictionary)
    func onAuthenticationFail(message: String)
    func onSignOutSuccessful(dictionary: NSDictionary)
}

public class WCSignIn: NSObject, WebServiceDelegate {

    var mainStoryBoard = UIStoryboard()
    var mutDictParams = NSMutableDictionary()
    
    public var delegate : WeCardsSignInDelegate!
    static let shared = WCSignIn()
    
    var targetVC: UIViewController!
    
    public class func sharedInstance() -> WCSignIn {
        return shared
    }
    
    func initialize() {
        
        //Get Required Params
        let aDictParams = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist") ?? "") ?? NSDictionary()
        
        //Developer Validations
        let aArrParams = aDictParams.object(forKey: "CFBundleURLTypes") as? NSArray ?? NSArray()

        if aArrParams.count == 0 {
            
            print("*** Uncaught exception 'InvalidOperationException', reason: 'CFBundleURLTypes is not registered in your Info.plist. Please add it in your Info.plist'")
            return
        }
        else if !((aArrParams.object(at: 0) as! NSDictionary).allKeys as NSArray).contains("CFBundleURLName") {
            
            print("*** Uncaught exception 'InvalidOperationException', reason: 'wecards1234****** is not registered as a URL scheme. Please add it in your Info.plist'")
            return
        }
        else if !((aArrParams.object(at: 0) as! NSDictionary).allKeys as NSArray).contains("CFBundleURLName") {
            
            print("*** Uncaught exception 'InvalidOperationException', reason: 'com.companyname.appname is not registered as a bundle URL name. Please add it in your Info.plist'")
            return
        }
        else if !(aDictParams.allKeys as NSArray).contains(Constant.structStatic.kAppId) {
            
            print("*** Uncaught exception 'InvalidOperationException', reason: '1234************ is not registered as a WeCardsAppID. Please add it in your Info.plist'")
            return
        }
        
        //Set Params
        mutDictParams.setValue(((aDictParams.object(forKey: "CFBundleURLTypes") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "CFBundleURLName") as? String ?? "", forKey: "bundle_identifier")
        mutDictParams.setValue(Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "", forKey: "app_name")
        mutDictParams.setValue(aDictParams.object(forKey: Constant.structStatic.kAppId), forKey: "app_id")

        //Initialization
        mainStoryBoard = UIStoryboard(name: "WeCards", bundle: Bundle(for: WCSignIn.self))
    }
    
    public func presentViewController(viewController: UIViewController!) {
        
        targetVC = viewController
        
        initialize()
        
        //Check & redirect to either app if installed or open custom dialogue of login with WeCards
        let aStrCustomUrl = String(format: "wecards://?id=wecardsAuth&redirect_uri=%@&packagename=%@", mutDictParams.value(forKey: "app_id") as? String ?? "", mutDictParams.value(forKey: "bundle_identifier") as? String ?? "")
        let aUrl = URL(string: aStrCustomUrl)!
        
        if UIApplication.shared.canOpenURL(aUrl) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(aUrl, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(aUrl)
            }
        }
        else {
            presentLoginViewController()
        }
    }
    
    func presentLoginViewController() {
        
        //Present login popup
        let aObjSignVC = mainStoryBoard.instantiateViewController(withIdentifier: "WCSignInVC") as! WCSignInVC
        aObjSignVC.mutDictParams = ["api_key": mutDictParams.value(forKey: "app_id") as? String ?? "",
                                    "packagename": mutDictParams.value(forKey: "bundle_identifier") as? String ?? "",
                                    "app_name": mutDictParams.value(forKey: "app_name") as? String ?? ""]
        
        if let window = UIApplication.shared.delegate?.window {
            
            /*window?.windowLevel = UIWindow.Level.alert
             window?.rootViewController?.addChild(aObjSignVC)
             window?.rootViewController?.view.addSubview(aObjSignVC.view)*/
            
            window?.addSubview(aObjSignVC.view)
            aObjSignVC.didMove(toParent: targetVC)
            targetVC.addChild(aObjSignVC)
        }
        
        aObjSignVC.didMove(toParent: targetVC)
    }
    
    public func signOut(viewController: UIViewController!, userId: String!, loginToken: String!) {
        
        let aMutDictParams: NSMutableDictionary = ["api_key": mutDictParams.value(forKey: "app_id") as? String ?? "",
                                                   "packagename": mutDictParams.value(forKey: "bundle_identifier") as? String ?? "",
                                                   "user_id": userId,
                                                   "login_token": loginToken]
        
        DispatchQueue.global(qos: .default).async {
            CCSWebServiceModal().callWebservice(aStrUrl: "open/user/logout", aMutDictParams: aMutDictParams, ref: self, aStrTag: "WS_SIGNOUTWITHWECARDS")
        }
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let aStrUrl = String(format: "%@", url as CVarArg)
        let aStrComponent: NSArray = NSArray(array: (aStrUrl.removingPercentEncoding)?.components(separatedBy: "?") ?? Array())
        
        let aArrComponent = (aStrComponent.object(at: 1) as? String ?? "").components(separatedBy: "&")
        responseHandler(dictionary: prepareDictFromArray(array: aArrComponent as NSArray))
        
        return true
    }
    
    func responseHandler(dictionary: NSMutableDictionary) {
        
        if dictionary.object(forKey: "access_denied") as? String ?? "" == "0" {
            
            dictionary.removeObject(forKey: "access_denied")
            
            if (delegate != nil) {
                delegate?.onAuthenticationSuccessful(dictionary: dictionary)
            }
        }
        else {
            
            if (delegate != nil) {
                delegate?.onAuthenticationFail(message: String(format: "Authentication Failed. Reason: '%@'", dictionary.object(forKey: "message") as? String ?? ""))
            }
        }
    }
    
    func prepareDictFromArray(array: NSArray) -> NSMutableDictionary {
        
        let aMutDictParams = NSMutableDictionary()
        
        for i in 0..<array.count {
            
            let aStrParams: String = array.object(at: i) as? String ?? ""
            
            let aArrElement: NSArray = aStrParams.components(separatedBy: "=") as NSArray
            aMutDictParams.setValue(aArrElement.object(at: 1) as? String ?? "", forKey: aArrElement.object(at: 0) as? String ?? "")
        }
        
        return aMutDictParams
    }
    
    //MARK: - Webservice Delegate Methods
    
    func getWebserviceResponse(aDictResponse: NSDictionary, aStrTag: String) throws {
        
        if aStrTag == Constant.structStatic.KMsgNoInternet {
            return
        }
        
        if aStrTag == "WS_SIGNOUTWITHWECARDS" {
            
            if ((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "status") as! NSString).isEqual(to: "success")
            {
                if (delegate != nil) {
                    delegate?.onSignOutSuccessful(dictionary: aDictResponse.object(forKey: "result") as! NSDictionary)
                }
            }
            else {
                
            }
        }
    }
    
}
