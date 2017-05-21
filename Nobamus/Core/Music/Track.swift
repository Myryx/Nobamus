//
//  Track.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation

class Track {
    var id: Int!
    var title = ""
    var artist = ""
    var albumTitle = ""
    
    init(id: Int, title: String, artist:String, albumTitle:String){
        self.id = id
        self.title = title
        self.artist = artist
        self.albumTitle = albumTitle
    }
}
