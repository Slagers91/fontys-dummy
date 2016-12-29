//
//  DataService.swift
//  Fontys-Dummys
//
//  Created by Ruud Slagers on 27/12/2016.
//  Copyright © 2016 Ruud Slagers. All rights reserved.
//

import Foundation
import Firebase

//Haalt de URL van de Firebase uit GoogleService, zodat die kan connecten
let DB_BASE = FIRDatabase.database().reference()

let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    //Dit schrijft naar Firebase
    static let ds = DataService()
    
    //DB verwijzing
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Opslag verwijzing
    private var _REF_POSTS_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POSTS_IMAGES: FIRStorageReference {
        return _REF_POSTS_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
}
