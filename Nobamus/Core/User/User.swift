//
//  User.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/20/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation

class User {
    static let sharedInstance = User()
    private init() { }
    
    var numberOfRequestsExecuted = 0
    var storeFrondID: Int?
    var uniqueID: String?
    var name: String = ""
    var latitude: Double?
    var longtitude: Double?
}
