//
//  DatabaseManager.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class DatabaseManager {
    static var ref = FIRDatabase.database().reference()
    
    static func createOrUpdateUser(userID: String, name: String, country: String) {
        ref.child("users").child(userID).setValue(["id": userID, "name": name, "country": country])
    }
    
    static func updateUser(key: String, value: Any) {
        guard let userId = User.sharedInstance.uniqueID else { return }
        ref.child("users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            ref.child("users/\(userId)/" + key).setValue(value)
            
        }) { error in
            print("Update user error: " + error.localizedDescription)
        }
    }
    
    static func getUser(with id: String) {
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { snapshot in
            print("User:\(snapshot)")
        }) { error in
            print("Update user error: " + error.localizedDescription)
        }
    }
}
