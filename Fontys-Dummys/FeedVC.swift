//
//  FeedVC.swift
//  Fontys-Dummys
//
//  Created by Ruud Slagers on 26/12/2016.
//  Copyright © 2016 Ruud Slagers. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    

    //Als je op uitloggen klikt, gooi de gegevens uit de keychainwrapper zodat je opnieuw kan inloggen
    
    @IBAction func signInTapped(_ sender: Any) {
    
        let keychainResult = KeychainWrapper.standard.remove(key: (KEY_UID))
        print("RUUD: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

    
}
