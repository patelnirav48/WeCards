//
//  WCSignInVC.swift
//  WeCardsSignIn-Example
//
//  Created by Nirav Patel on 28-09-18.
//  Copyright © 2018 Nirav Patel. All rights reserved.
//

import UIKit
import CoreTelephony
import SafariServices

class WCSignInVC: UIViewController, WebServiceDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var mutDictParams = NSMutableDictionary()
    
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var lblSigninWeCards: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblSignin: UILabel!
    @IBOutlet weak var lblSigninSubtitle: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPrivacyMsg: UILabel!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bundle: Bundle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setLayoutMethod()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - User Defined Methods
    
    func setLayoutMethod() {
        
        bundle = Bundle(for: self.classForCoder)
        
        if let bundlePath = bundle.resourcePath?.appendingFormat("/WeCardsResources.bundle"), let resourceBundle = Bundle(path: bundlePath) {
            bundle = resourceBundle
        }
        
        //Add Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        //Register Font
        UIFont.registerFont(file: "Muli.ttf", bundle: bundle)
        UIFont.registerFont(file: "Muli-Light.ttf", bundle: bundle)
        UIFont.registerFont(file: "Muli-Bold.ttf", bundle: bundle)
        
        imgAppLogo.image = UIImage(named: "imgAppIcon", in: bundle, compatibleWith: nil)
        
        lblSigninWeCards.text = NSLocalizedString("LBL_SIGNINWITHWECARDS", tableName: "", bundle: bundle, value: "", comment: "")
        lblSigninWeCards.font = Constant.FONT.Regular.of(size: 14.0)
        lblSigninWeCards.textColor = Constant.color.kTextColor
        
        btnClose.setImage(UIImage(named: "imgCancel", in: bundle, compatibleWith: nil), for: .normal)
        
        lblSignin.text = NSLocalizedString("LBL_SIGNIN", tableName: "", bundle: bundle, value: "", comment: "")
        lblSignin.font = Constant.FONT.Bold.of(size: 26.0)
        lblSignin.textColor = Constant.color.kTextColor
        
        lblSigninSubtitle.text = String(format: NSLocalizedString("LBL_SIGNINSUBTITLE", tableName: "", bundle: bundle, value: "", comment: ""), mutDictParams.object(forKey: "app_name") as? String ?? "")
        lblSigninSubtitle.font = Constant.FONT.Regular.of(size: 14.0)
        lblSigninSubtitle.textColor = Constant.color.kTextColor
        
        txtCountryCode.placeholder = NSLocalizedString("LBL_COUNTRYCODE", tableName: "", bundle: bundle, value: "", comment: "")
        txtCountryCode.font = Constant.FONT.Regular.of(size: 17.0)
        txtCountryCode.textColor = Constant.color.kTextColor
        txtCountryCode.text = String(format: "+%@", methodToGetCountryCodeBasedOnCarier().object(forKey: "country_code") as? String ?? "1")
        
        txtPhoneNumber.placeholder = NSLocalizedString("LBL_PHONENUMBER", tableName: "", bundle: bundle, value: "", comment: "")
        txtPhoneNumber.font = Constant.FONT.Regular.of(size: 17.0)
        txtPhoneNumber.textColor = Constant.color.kTextColor
        
        txtPassword.placeholder = NSLocalizedString("LBL_PASSWORD", tableName: "", bundle: bundle, value: "", comment: "")
        txtPassword.font = Constant.FONT.Regular.of(size: 17.0)
        txtPassword.textColor = Constant.color.kTextColor
        
        lblPrivacyMsg.text = String(format: NSLocalizedString("LBL_PRIVACYMESSAGE", tableName: "", bundle: bundle, value: "", comment: ""), mutDictParams.object(forKey: "app_name") as? String ?? "")
        lblPrivacyMsg.font = Constant.FONT.Regular.of(size: 14.0)
        lblPrivacyMsg.textColor = Constant.color.kTextColor
        
        btnCreateAccount.setTitle(NSLocalizedString("LBL_CREATEACCOUNT", tableName: "", bundle: bundle, value: "", comment: ""), for: .normal)
        btnCreateAccount.titleLabel?.font = Constant.FONT.Regular.of(size: 17.0)
        btnCreateAccount.setTitleColor(Constant.color.kThemeColor, for: .normal)
        
        btnSignIn.setTitle(NSLocalizedString("LBL_SIGNIN", tableName: "", bundle: bundle, value: "", comment: ""), for: .normal)
        btnSignIn.titleLabel?.font = Constant.FONT.Regular.of(size: 17.0)
        btnSignIn.setTitleColor(.white, for: .normal)
        btnSignIn.backgroundColor = Constant.color.kThemeColor
        btnSignIn.layer.masksToBounds = true
        btnSignIn.layer.cornerRadius = 4.0
        
        btnPrivacy.setTitle(NSLocalizedString("LBL_PRIVACY", tableName: "", bundle: bundle, value: "", comment: ""), for: .normal)
        btnPrivacy.titleLabel?.font = Constant.FONT.Regular.of(size: 14.0)
        btnPrivacy.setTitleColor(Constant.color.kTextColor, for: .normal)
        
        btnTerms.setTitle(NSLocalizedString("LBL_TERMS", tableName: "", bundle: bundle, value: "", comment: ""), for: .normal)
        btnTerms.titleLabel?.font = Constant.FONT.Regular.of(size: 14.0)
        btnTerms.setTitleColor(Constant.color.kTextColor, for: .normal)
        
        viewLogin.layer.masksToBounds = true
        viewLogin.layer.cornerRadius = 4.0
    }
    
    @objc func handleGesture() {
        
        self.view.endEditing(true)
    }
    
    func callWebserviceForLoginWithWeCards() {

        activityIndicator.startAnimating()
        
        btnSignIn.setTitle("", for: .normal)
        btnSignIn.isUserInteractionEnabled = false
        
        var aStrCountryCode = txtCountryCode.text ?? ""
        aStrCountryCode.remove(at: aStrCountryCode.startIndex)
        
        let aMutDictParams: NSMutableDictionary = ["api_key": mutDictParams.object(forKey: "api_key") as? String ?? "",
                                                   "packagename": mutDictParams.object(forKey: "packagename") as? String ?? "",
                                                   "country_code": aStrCountryCode,
                                                   "phone_number": txtPhoneNumber.text ?? "",
                                                   "password": txtPassword.text ?? "",
                                                   "login_with": "1",
                                                   "device_type": "1",
                                                   "device_token": ""]
        
        DispatchQueue.global(qos: .default).async {
            CCSWebServiceModal().callWebservice(aStrUrl: "open/user/login", aMutDictParams: aMutDictParams, ref: self, aStrTag: "WS_LOGINWITHWECARDS")
        }
        
    }
    
    @IBAction func btnClickAction(_ sender: Any) {
        
        let aBtnSender = sender as! UIButton
        
        if aBtnSender == btnCreateAccount {
            
            methodToOpenURL(aStrUrl: Constant.structStatic.kAppUrl)
        }
        else if aBtnSender == btnSignIn {
            
            var aStrMessage: String = ""
            
            //Validation
            if (txtCountryCode.text)?.trimmingCharacters(in: .whitespaces) == "+" {
                
                aStrMessage = "ERR_COUNTRYCODEREQ"
            }
            else if (txtPhoneNumber.text)?.trimmingCharacters(in: .whitespaces) == "" {
                
                aStrMessage = "ERR_PHONENUMBERREQ"
            }
            else if txtPhoneNumber.text?.count ?? 0 < 6 {
                
                aStrMessage = "ERR_PASSWORDLIMIT"
            }
            else if (txtPassword.text)?.trimmingCharacters(in: .whitespaces) == "" {
                
                aStrMessage = "ERR_PASSWORDREQ"
            }
            
            if aStrMessage != "" {
                
                UIViewController.presentAlert(title: "", message: aStrMessage, options: "LBL_OK") { (option) in
                }
                
                return
            }
            
            //Call API
            self.view.endEditing(true)
            callWebserviceForLoginWithWeCards()
        }
        else if aBtnSender == btnTerms {
            
            methodToLoadURLOnSafariViewController(aStrUrl: Constant.structStatic.kTerms, viewController: self)
        }
        else if aBtnSender == btnPrivacy {
            
            methodToLoadURLOnSafariViewController(aStrUrl: Constant.structStatic.kPrivacy, viewController: self)
        }
        else if aBtnSender == btnClose {
            
            self.view.removeFromSuperview()
        }
    }
    
    func methodToLoadURLOnSafariViewController(aStrUrl: String, viewController:AnyObject!) {
        
        let aSocialUrl = URL(string: aStrUrl)!
        
        if #available(iOS 9.0, *) {
            viewController.present(SFSafariViewController(url: aSocialUrl), animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(aSocialUrl)
        }
    }
    
    func methodToOpenURL(aStrUrl: String) {
        
        guard let url = URL(string: aStrUrl) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK: - Get Country Related Data
    
    func methodToGetCountryCodes() -> NSArray {
        
        var countryList = NSArray()
        
        let aStrFilePath = bundle.path(forResource: "PhoneCountries", ofType: "txt")!
        let aDataOfPath = NSData(contentsOfFile: aStrFilePath)
        var aStrData: NSString = NSString()
        
        if aDataOfPath != nil {
            aStrData = NSString(data: aDataOfPath! as Data , encoding: String.Encoding.utf8.rawValue)!
        }
        
        if aDataOfPath == nil {
            return countryList
        }
        
        let delimeter = ";"
        let endOfLine = "\n"
        
        let mutArrList = NSMutableArray()
        var currentLocation = 0
        
        while true {
            
            let codeRange = (aStrData.range(of: delimeter, options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(currentLocation, ((aStrData.length) - currentLocation))))
            
            if codeRange.location == NSNotFound {
                break
            }
            
            let countryCode = Int((aStrData.substring(with: NSMakeRange(currentLocation, codeRange.location - currentLocation))))
            
            let idRange = (aStrData.range(of: delimeter, options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(codeRange.location + 1 , aStrData.length - (codeRange.location + 1))))
            
            if idRange.location == NSNotFound {
                break
            }
            
            let countryId = (aStrData.substring(with: NSMakeRange(codeRange.location + 1 , idRange.location - (codeRange.location + 1)))).uppercased()
            let nameRange = aStrData.range(of:endOfLine , options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(idRange.location + 1, aStrData.length - (idRange.location + 1)))
            
            if nameRange.location == NSNotFound {
                break
            }
            
            var countryname = aStrData.substring(with: NSMakeRange(idRange.location + 1, nameRange.location - (idRange.location + 1))) as NSString
            if countryname.hasSuffix("\r") {
                countryname = countryname.substring(to: countryname.length - 1) as NSString
            }
            
            let arrOfObject : Array = [NSNumber(value: countryCode!), countryId, countryname] as [Any]
            mutArrList.add(arrOfObject)
            
            currentLocation = Int(nameRange.location) + Int(nameRange.length);
            
            if nameRange.length > 1 {
                break;
            }
        }
        
        countryList = mutArrList
        
        return countryList
    }
    
    func methodToGetCountryCodeBasedOnCarier() -> NSDictionary {
        
        var countryId : NSString? = nil
        let networkInfo = CTTelephonyNetworkInfo()
        
        let carrier = networkInfo.subscriberCellularProvider
        if carrier != nil {
            
            let mcc = carrier?.isoCountryCode
            
            if mcc != nil {
                countryId = mcc as NSString?
            }
        }
        
        if countryId == nil {
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
            {
                countryId = countryCode as NSString
            }
        }
        
        let code = 0
        let aDicCountryData = self.countryName(byCountryId: countryId! as String, code: code)
        
        if aDicCountryData.object(forKey: "country_code") as! Int == 0 {
            aDicCountryData.setValue(0, forKey: "country_code")
        }
        
        return aDicCountryData as NSDictionary
    }
    
    func countryName(byCountryId countryId: String, code: Int) -> NSDictionary
    {
        var aDicData = NSDictionary()
        
        let normalizedCountryId: String = countryId.uppercased()
        let arrCountryData = methodToGetCountryCodes()
        
        for index in 0..<arrCountryData.count
        {
            let aArray : NSArray = arrCountryData.object(at: index) as! NSArray
            let itemCountryId = aArray.object(at: 1) as! NSString
            
            if (itemCountryId as String == normalizedCountryId) {
                
                let countryCode = aArray[0] as! Int
                aDicData = ["country_name": aArray.object(at: 2),
                            "country_code": countryCode]
                
                return aDicData
            }
        }
        
        return aDicData
    }
    
    // MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aStrText  = textField.text! + string
        
        if textField == txtCountryCode && string != "" {
            
            if aStrText.count > 4 {
                return false
            }
        }
        
        if textField == txtPhoneNumber && string != "" {
            
            if aStrText.count > 15 {
                return false
            }
        }
        
        if textField == txtCountryCode {
            
            let compSepByCharInSet = string.components(separatedBy: NSCharacterSet(charactersIn:"0123456789").inverted)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string != numberFiltered {
                return false
            }
        }
        
        if textField == txtCountryCode {
            
            if(range.location == 0) {
                return false
            }
            
            if string == "" && textField.text == "+" {
                return false
            }
            else if(range.location == 0 && string == "") {
                return false
            }
        }
        
        return true
    }
    
    //MARK: - Webservice Delegate Methods
    
    func getWebserviceResponse(aDictResponse: NSDictionary, aStrTag: String) throws {
        
        activityIndicator.stopAnimating()
        
        btnSignIn.setTitle(NSLocalizedString("LBL_SIGNIN", tableName: "", bundle: bundle, value: "", comment: ""), for: .normal)
        btnSignIn.isUserInteractionEnabled = true

        if aStrTag == Constant.structStatic.KMsgNoInternet {
            return
        }
        
        if aStrTag == "WS_LOGINWITHWECARDS" {
            
            var aMutDictResponse = NSMutableDictionary()
            
            if ((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "status") as! NSString).isEqual(to: "success")
            {
                aMutDictResponse = NSMutableDictionary(dictionary: (aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSDictionary)
                aMutDictResponse.setValue("0", forKey: "access_denied")
                
                self.view.removeFromSuperview()
            }
            else {
                
                aMutDictResponse.setValue((aDictResponse.object(forKey: "result") as! NSDictionary).object(forKey: "message") as? String ?? "", forKey: "message")
                aMutDictResponse.setValue("1", forKey: "access_denied")
            }
            
            WCSignIn.sharedInstance().responseHandler(dictionary: aMutDictResponse)
        }
    }
}

public extension UIFont {
    
    public static func registerFont(file: String, bundle: Bundle) {
        
        guard let pathForResourceString = bundle.path(forResource: file, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}

extension UIViewController {
    
    static func presentAlert(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        
        var bundle = Bundle(for: WCSignIn.self)

        if let bundlePath = bundle.resourcePath?.appendingFormat("/WeCardsResources.bundle"), let resourceBundle = Bundle(path: bundlePath) {
            bundle = resourceBundle
        }
        
        let alertController = UIAlertController(title: NSLocalizedString(title, tableName: "", bundle: bundle, value: "", comment: ""), message: NSLocalizedString(message, tableName: "", bundle: bundle, value: "", comment: ""), preferredStyle: .alert)
        
        for (index, option) in options.enumerated() {
            
            alertController.addAction(UIAlertAction.init(title: NSLocalizedString(option, tableName: "", bundle: bundle, value: "", comment: ""), style: .default, handler: { (action) in
                completion(index)
            }))
        }
        
        if let window = UIApplication.shared.windows.last {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
