//
//  Static instance of User class that represents the user of the applciation and his data
//

import Foundation

class User {
    static let sharedInstance = User()
    private init() { }
    
    var numberOfRequestsExecuted = 0
    var storeFrondID: Int?
    var uniqueID: String!
    var name = ""
    var latitude: Double?
    var longitude: Double?
    var country = NSLocale.current.regionCode ?? ""
}
