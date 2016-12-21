//
//  ViewController.swift
//  Fontys-Dummys
//
//  Created by Ruud Slagers on 18/12/2016.
//  Copyright © 2016 Ruud Slagers. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func facebookBtnTapped(_ sender: Any) {
    
    
    
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("RUUD: Unable to authenticate with Facebook - \(error)")
            }
            else if result?.isCancelled == true {
                print("RUUD: User cancelled Facebook authentication")
            } else {
                print("RUUD: Succesfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("RUUD: Unable to authenticate with Firebase - \(error)")
            } else {
                print("RUUD: Succesfully authenticated with Firebase")
            }
        })
    }
    
}

