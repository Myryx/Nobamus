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

enum UserKeys: String {
    case id
    case country
    case latitude
    case longitude
    case name
    case track
}

class DatabaseManager {
    static var ref = FIRDatabase.database().reference()
    
    static func createOrUpdateUser(userID: String, name: String, country: String) {
        updateUser(key: UserKeys.id.rawValue, value: userID)
        updateUser(key: UserKeys.name.rawValue, value: name)
        updateUser(key: UserKeys.country.rawValue, value: country)
    }
    
    // MARK update
    static func updateUser(key: String, value: Any, completion: @escaping () -> () = { _ in }) {
        guard let userId = User.sharedInstance.uniqueID else { return }
        ref.child("users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            ref.child("users/\(userId)/" + key).setValue(value, withCompletionBlock: { (error, ref) in
                completion()
            })
            
        }) { error in
            print("Update user error: " + error.localizedDescription)
        }
    }
    
    static func updateUserTrack(track: Track) {
        updateUser(key: "track", value: TrackTranslator().translateToDictionary(track))
    }
    
    static func updatePlaybackInfo(playbackTime: Double, isPlaying: Bool, overallPlaybackTime: Double) {
        updateUser(key: "playbackTime", value: playbackTime)
        updateUser(key: "isPlaying", value: isPlaying)
        updateUser(key: "overallPlaybackTime", value: overallPlaybackTime)
    }
    
    static func updateOnlineState(isOnline: Bool, completion: @escaping () -> () = { _ in }) {
        updateUser(key: "isOnline", value: isOnline, completion: completion)
    }
    
    // MARK: get
    static func getPerson(with id: String, completion: @escaping (Person?) -> Void) {
        var person: Person? = nil
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { snapshot in
            person = PersonTranslator().translateFrom(snapshot: snapshot)
            completion(person)
        }) { error in
            print("Error while retreiving user:" + error.localizedDescription)
        }
    }
    
    // MARK: observe
    static func observePersonChanges(id: String, at indexPath: IndexPath, completion: @escaping (Person?, IndexPath) -> Void) {
        
        ref.child("users").child(id).observe(.value, with: { snapshot in
            if let person = PersonTranslator().translateFrom(snapshot: snapshot) {
                completion(person, indexPath)
            }
        }) { error in
            print("Error while retreiving user:" + error.localizedDescription)
        }
    }
    
    static func detachObserver(for id: String) {
        ref.child("users").child(id).removeAllObservers()
    }
}
