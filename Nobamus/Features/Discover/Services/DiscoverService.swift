//
//  Service for getting ids of all online users in the country
//

import Foundation
import CoreLocation
import Alamofire

class DiscoverService {
    
    func getIdsOfUsersAround(location: CLLocation, country: String, completion: @escaping ([String]?, Error?) -> Void) {
        Alamofire.request("https://us-central1-nobamus-f315a.cloudfunctions.net/closestUsers?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&country=\(country)").responseJSON { response in
            guard let userIds = response.result.value as? [String] else {
                completion(nil, APIError.apiError("Couldn't get identifiers of people around"))
                return
            }
            completion(userIds, nil)
        }
    }
}
