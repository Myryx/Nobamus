import FirebaseDatabase

enum PersonKeys: String {
    case name
    case playbackTime
    case overallPlaybackTime
    case isPlaying
    case track
}

class PersonTranslator: Translator {
    
    func translateFrom(dictionary json: [String : Any]) -> Person? {
        guard
            let name = json[PersonKeys.name.rawValue] as? String,
            let playbackTime = json[PersonKeys.playbackTime.rawValue] as? Double,
            let overallPlaybackTime = json[PersonKeys.overallPlaybackTime.rawValue] as? Double,
            let isPlaying = json[PersonKeys.isPlaying.rawValue] as? Bool,
            let trackJson = json[PersonKeys.track.rawValue] as? [String : Any],
            let track = TrackTranslator().translateFrom(dictionary:trackJson)
            else {
                return nil
        }
        
        return Person(name: name, track: track, playbackTime: playbackTime, overallPlaybackTime: overallPlaybackTime, isPlaying: isPlaying)
    }
    
    func translateFrom(snapshot: FIRDataSnapshot) -> Person? {
        guard let value = snapshot.value as? NSDictionary else { return nil }
        guard
            let name = value[PersonKeys.name.rawValue] as? String,
            let playbackTime = value[PersonKeys.playbackTime.rawValue] as? Double,
            let overallPlaybackTime = value[PersonKeys.overallPlaybackTime.rawValue] as? Double,
            let isPlaying = value[PersonKeys.isPlaying.rawValue] as? Bool,
            let trackJson = value[PersonKeys.track.rawValue] as? [String : Any],
            let track = TrackTranslator().translateFrom(dictionary:trackJson)
            else {
                return nil
        }
        
        return Person(name: name, track: track, playbackTime: playbackTime, overallPlaybackTime: overallPlaybackTime, isPlaying: isPlaying)
    }
    
    func translateToDictionary(_ object: Person) -> [String : Any] {
        return [PersonKeys.name.rawValue: object.name, PersonKeys.track.rawValue: object.track.title]
    }
}
