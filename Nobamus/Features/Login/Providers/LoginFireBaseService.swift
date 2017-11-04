//
//  Service that provides the Firebase authentication
//

import Foundation
import FirebaseAuth
import CoreLocation

protocol FirebaseLoginDelegate: class {
    func successfulFirebaseLogin()
}

class LoginFirebaseService {
    weak var delegate: FirebaseLoginDelegate?
    func signInAnonymouslyFireBase(with userName: String) {
        User.sharedInstance.name = userName
        FIRAuth.auth()?.signInAnonymously() { [weak self] (user, error) in
            guard error == nil, let userID = user?.uid else { return }
            User.sharedInstance.uniqueID = userID
            let country = NSLocale.current.regionCode ?? ""
            DatabaseManager.createOrUpdateUser(userID: userID, name: userName, country: country)
            UserDefaults.standard.set(userName, forKey: "userName")
            self?.delegate?.successfulFirebaseLogin()
            print("Firebase id is: \(userID)")
        }
    }
}
