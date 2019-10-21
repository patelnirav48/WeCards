
import UIKit
import Foundation

class Constant: NSObject {
  
    enum FONT: String {
        
        case Regular = "Muli"
        case Bold = "Muli-Bold"
        case Light = "Muli-Light"
        
        func of(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size * (Constant.structDeviceScreen.kScreenWidth / 345))!
        }
        
    }
    
    struct structCommanUrl
    {
        //Constant define here.
        static let kLocalUrl = "http://192.168.0.14/wecards/api/"
        static let kDevUrl = "http://mmc-apps.com/wecards/api/"
        static let kLiveUrl = "https://www.we.cards/wecards/api/?r="

        //Change only this
        static let kApiUrl = kLiveUrl

        static let kCommanUrl = kApiUrl + "v1_1/"
    }
    
    struct structApi {
        
        static let kAPIKey = ""
        static let kAPISecret = ""
    }
    
    struct structDeviceScreen {
        
        static let kScreenWidth = UIScreen.main.bounds.size.width
        static let kScreenHeight = UIScreen.main.bounds.size.height
    }
    
    struct color {
        
        static let kTextColor =  UIColor(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1.0)
        static let kThemeColor =  UIColor(red: 0.0/255.0, green: 133.0/255.0, blue: 214.0/255.0, alpha: 1.0)

    }

    struct structStatic {
        
        static let kMsgDuration = 4.0
        static let KMsgNoInternet = NSLocalizedString("MSG_NO_INTERNET", comment: "")
        
        static let kAppId = "WeCardsAppID"
        
        static let kPrivacy = "https://www.we.cards/privacy_policy.php?from=mobile"
        static let kTerms = "https://www.we.cards/terms_and_condition.php?from=mobile"
        static let kAppUrl = "itms://itunes.apple.com/app/wecards/id1154071458?mt=8"
    }
    
    struct GlobalDeclaration {
        
        static var dictUserLocation = NSDictionary()
    }
    
}


