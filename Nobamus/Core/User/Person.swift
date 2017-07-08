//
//  Person.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation

struct Person {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    var track: Track
    init(name: String, track: Track) {
        self.name = name
        self.track = track
    }
}
