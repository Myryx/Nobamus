enum PersonKeys: String {
    case name
    case title
}

class PersonTranslator: Translator {
    
    func translateFrom(dictionary json: [String : Any]) throws -> Person {
        guard let name = json[PersonKeys.name.rawValue] as? String,
            let title = json[PersonKeys.title.rawValue] as? String else { throw TranslatorError.invalidJSONObject }
        return Person(name: name, latitude: 0, longitude: 0, track: Track(id: 0, title: title, artist: "", albumTitle: ""))
    }
    
    func translateToDictionary(_ object: Person) -> [String : Any] {
        return [PersonKeys.name.rawValue: object.name, PersonKeys.title.rawValue: object.track.title]
    }
}
