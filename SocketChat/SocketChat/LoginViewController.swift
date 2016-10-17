//
//  LoginViewController.swift
//  SocketChat
//
//  Created by user on 13/10/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class LoginViewcontroller: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }

    

    @IBAction func loginAction(sender: AnyObject) {
        
        if usernameField.text?.isEmpty == false && passwordField.text?.isEmpty == false {
            
            let params:NSDictionary = ["email":usernameField.text!, "password":passwordField.text!]
            APIClient.loginAPI(params, successCallBack: { (response) -> () in
                if let _ = response {
                    if let token = response!["authentication_token"] as? String {
                        (UIApplication.sharedApplication().delegate as! AppDelegate).userToken = token
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "userToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        (UIApplication.sharedApplication().delegate as! AppDelegate).showHomeScreen()
                        SocketIOManager.sharedInstance.establishConnection()
                    }
                    
                }
                
                }, failureCallBack: { (failureMessage) -> () in
                    
            })
          
            
        }
        
    }
    
}

