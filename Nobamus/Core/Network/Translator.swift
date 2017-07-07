import Foundation

enum TranslatorError: Error{
    case invalidObjectsInArray
    case invalidJSONObject
}

protocol Translator {
    associatedtype T
    func translateFrom(dictionary json: [String : Any]) throws -> T
    func translateFrom(array json: [Any]) throws -> [T]
    func translateToDictionary(_ object: T) -> [String : Any]
    func translateToArray(_ arrayOfObjects: [T]) -> [Any]
}

extension Translator {
    func translateFrom(array: [Any]) throws -> [T] {
        return try array.map {
            guard let object = $0 as? [String: Any] else {
                throw TranslatorError.invalidObjectsInArray
            }
            return try translateFrom(dictionary: object)
        }
    }
    
    func translateToArray(_ arrayOfObjects: [T]) -> [Any]{
        return arrayOfObjects.map { translateToDictionary($0) }
    }
}
