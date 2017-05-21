//
//  LoginFireBaseProvider.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import FirebaseAuth
import CoreLocation

class LoginFireBaseProvider {
    static func signInAnonymouslyFireBase(userName: String) {
        User.sharedInstance.name = userName
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if((error) == nil) {
                User.sharedInstance.uniqueID = user?.uid
                
                callback((user?.uid)!, userName, CLLocation(latitude: 0, longitude: 0))
                print("Firebase id is: \(user?.uid ?? "NIL")")
            }
            else{
                print("Can't login anonimously")
            }
        }
    }
}
