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
    let latitude: Double = 0.0
    let longitude: Double = 0.0
    let country: String = NSLocale.current.regionCode ?? ""
    var track: Track
    var playbackTime: Double = 0.0
    var overallPlaybackTime: Double = 0.0
    var isPlaying: Bool = false
    init(name: String, track: Track, playbackTime: Double, overallPlaybackTime: Double, isPlaying: Bool) {
        self.name = name
        self.track = track
        self.playbackTime = playbackTime
        self.isPlaying = isPlaying
        self.overallPlaybackTime = overallPlaybackTime
    }
}
