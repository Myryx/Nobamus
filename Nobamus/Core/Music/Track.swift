//
//  Track.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation

struct Track: Equatable {
    let id: String
    let title: String
    let artist: String
    let albumTitle: String
    
    public static func ==(lhs: Track, rhs: Track) -> Bool {
        return
                lhs.title == rhs.title &&
                lhs.id == rhs.id &&
                lhs.artist == rhs.artist &&
                lhs.albumTitle == rhs.albumTitle
    }
}
