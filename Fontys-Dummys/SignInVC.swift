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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Moet in de viewDidAppear omdat viewDidLoad geen performSegue kan uitvoeren
    override func viewDidAppear(_ animated: Bool) {
        //Als je al een keer bent ingelogd ga meteen door naar de overzichtpagina
        if let _ = KeychainWrapper.standard.string(forKey: (KEY_UID)) {
            print("RUUD: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    

    //Facebook knop
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("RUUD: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("RUUD: Unable to authenticate with Firebase using email")
                        } else {
                            print("RUUD: Succesfully authenticated with Firebase using email")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }

    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("RUUD: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)

    }
}


