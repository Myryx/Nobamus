//
//  TrackTranslator.swift
//  Nobamus

import Foundation

enum TrackKeys: String {
    case id
    case title
    case artist
    case albumTitle
}

class TrackTranslator: Translator {
    
    func translateFrom(dictionary json: [String : Any]) -> Track? {
        guard
            let id = json[TrackKeys.id.rawValue] as? Int,
            let title = json[TrackKeys.title.rawValue] as? String,
            let artist = json[TrackKeys.artist.rawValue] as? String,
            let albumTitle = json[TrackKeys.albumTitle.rawValue] as? String
            else { return nil }
        return Track(id: id, title: title, artist: artist, albumTitle: albumTitle)
    }
    
    func translateToDictionary(_ object: Track) -> [String : Any] {
        return [TrackKeys.id.rawValue: object.id, TrackKeys.title.rawValue: object.artist, TrackKeys.id.rawValue: object.id, TrackKeys.albumTitle.rawValue: object.id]
    }
}
