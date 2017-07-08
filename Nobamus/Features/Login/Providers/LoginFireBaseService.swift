//
//  Service that provides the Firebase authentication
//

import Foundation
import FirebaseAuth
import CoreLocation

class LoginFirebaseService {
    static func signInAnonymouslyFireBase(with userName: String) {
        User.sharedInstance.name = userName
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            guard error == nil,
                let userID = user?.uid else { return }
            User.sharedInstance.uniqueID = userID
            let country = NSLocale.current.regionCode ?? ""
            DatabaseManager.createOrUpdateUser(userID: userID, name: userName, country: country)
            print("Firebase id is: \(userID)")
        }
    }
}
