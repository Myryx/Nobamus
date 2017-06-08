//
//  Person.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation

class Person {
    
    // MARK: Properties
    
    /// URL with the preview that features the content inside
    var name: String
    
    var latitude:Double
    
    var longtitude: Double
    
    var track: Track
    
    init(name: String, latitude: Double, longtitude: Double, track: Track)
    {
        self.name = name
        self.latitude = latitude
        self.longtitude = longtitude
        self.track = track
    }
}
