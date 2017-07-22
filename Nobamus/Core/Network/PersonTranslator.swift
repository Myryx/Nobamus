import FirebaseDatabase

enum PersonKeys: String {
    case name
    case track
}

class PersonTranslator: Translator {
    
    func translateFrom(dictionary json: [String : Any]) -> Person? {
        guard
            let name = json[PersonKeys.name.rawValue] as? String,
            let trackJson = json[PersonKeys.track.rawValue] as? [String : Any],
            let track = TrackTranslator().translateFrom(dictionary:trackJson)
            else {
                return nil
        }
        
        return Person(name: name, track: track)
    }
    
    func translateFrom(snapshot: FIRDataSnapshot) -> Person? {
        guard let value = snapshot.value as? NSDictionary else { return nil }
        guard
            let name = value[PersonKeys.name.rawValue] as? String,
            let trackJson = value[PersonKeys.track.rawValue] as? [String : Any],
            let track = TrackTranslator().translateFrom(dictionary:trackJson)
            else {
                return nil
        }
        
        return Person(name: name, track: track)
    }
    
    func translateToDictionary(_ object: Person) -> [String : Any] {
        return [PersonKeys.name.rawValue: object.name, PersonKeys.track.rawValue: object.track.title]
    }
}
