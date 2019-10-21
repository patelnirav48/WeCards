//
//  ViewController.swift
//  WeCardsSignIn-Demo
//
//  Created by Nirav Patel on 04-10-18.
//  Copyright © 2018 Nirav Patel. All rights reserved.
//

import UIKit
import WeCardsSignIn

class ViewController: UIViewController, WeCardsSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func btnClickActions(_ sender: Any) {
        
        WCSignIn.sharedInstance().delegate = self
        WCSignIn.sharedInstance().presentViewController(viewController: self)
    }

    //MARK:- User Defined Delegate Methods
    
    func onAuthenticationSuccessful(dictionary: NSDictionary) {
        print("\(dictionary)")
    }
    
    func onAuthenticationFail(message: String) {
        print("\(message)")
    }
    
    func onSignOutSuccessful(dictionary: NSDictionary) {
        print("\(dictionary)")
    }
}

