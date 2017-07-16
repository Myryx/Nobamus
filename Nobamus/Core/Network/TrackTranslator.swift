//
//  TrackTranslator.swift
//  Nobamus

import Foundation
import MediaPlayer

enum TrackKeys: String {
    case id
    case title
    case artist
    case albumTitle
}

class TrackTranslator: Translator {
    
    func translateFrom(dictionary json: [String : Any]) -> Track? {
        guard
            let id = json[TrackKeys.id.rawValue] as? String,
            let title = json[TrackKeys.title.rawValue] as? String,
            let artist = json[TrackKeys.artist.rawValue] as? String,
            let albumTitle = json[TrackKeys.albumTitle.rawValue] as? String
            else { return nil }
        return Track(id: id, title: title, artist: artist, albumTitle: albumTitle)
    }
    
    func translateFrom(mediaItem item: MPMediaItem) -> Track? {
        guard
            let title = item.title,
            let artist = item.artist,
            let albumTitle = item.albumTitle
            else { return nil }
        return Track(id: item.playbackStoreID, title: title, artist: artist, albumTitle: albumTitle)
    }
    
    func translateToDictionary(_ object: Track) -> [String : Any] {
        return [TrackKeys.id.rawValue: object.id, TrackKeys.title.rawValue: object.title, TrackKeys.artist.rawValue: object.artist, TrackKeys.albumTitle.rawValue: object.albumTitle]
    }
}
