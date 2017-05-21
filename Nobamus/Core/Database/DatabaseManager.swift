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
import SwiftyJSON

class DatabaseManager {
    
    static let foundUsersAround = Notification.Name("foundUsersAround")
    static var ref: FIRDatabaseReference!
    static var peopleAround:[Person] = []
    
    static func setupDatabase(){
        ref = FIRDatabase.database().reference()
    }
    
    static func createOrUpdateUser(userID: String, name: String, location: CLLocation){
        let longtitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        ref.child("users").child(userID).setValue(["id": userID, "latitude": latitude, "longtitude": longtitude, "name": name, "title": "", "artist": "", "albumTitle": ""])
    }
    
    static func updateUser(key: String, value:Any){
        ref.child("users").child(User.sharedInstance.uniqueID!).observeSingleEvent(of: .value, with: { (snapshot) in
            ref.child("users/\(User.sharedInstance.uniqueID!)/" + key).setValue(value)
            
        }) { (error) in // if user doesn't exist
            print("Update user error: " + error.localizedDescription)
        }
    }
    
    dynamic static func getAllUsersAround(){
        peopleAround.removeAll()
        var tracks:[Track] = []
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var i = 0
            let users = JSON(value!)
            
            MusicManager.setNumberOfPeopleTracks(number: users.count - 1) // prepare for players, but witout User himself
            
            for (_, user) in users {
                
                if(user["id"].string == User.sharedInstance.uniqueID){ // excluding the user itself
                    continue
                }
                
                let track = Track(id: -1, title: user["title"].string!, artist: user["artist"].string!, albumTitle: user["albumTitle"].string!)
                switch(user["streamer"]){
                case "appleMusic":
                    track.streamer = Streamer.appleMusic
                    break
                case "spotify":
                    track.streamer = Streamer.spotify
                    break
                default:
                    track.streamer = Streamer.appleMusic
                }
                tracks.append(track)
                let personToCreate = Person(user["name"].string!, user["latitude"].double!, user["longtitude"].double!, track)
                MusicManager.getTrackID(title: track.title, artist: track.artist, albumTitle: track.albumTitle, position: i)
                peopleAround.append(personToCreate)
                i = i + 1
            }
            MusicManager.setPeopleTracks(tracks: tracks)
            NotificationCenter.default.post(name: foundUsersAround, object: nil)
            
        }) { (error) in // if user doesn't exist
            print("Couldn't get all users because of: " + error.localizedDescription)
        }
    }
}
