//
//  DiscoverService.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 7/7/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation

class DiscoverService {
    
    func getUsersAround(CLLocation location, completion: @escaping ([Person]?, Error?) -> Void) {
//        apiClient.get(endpoint: "v1/investments/portfolio") { (result: ParsedResult<[String: Any]>) in
//            switch result {
//            case let .success(json):
//                guard let jsonBrokerage = json["brokerAccounts"] as? [[String: Any]],
//                    let brokerageAccounts = try? BrokerageAccountTranslator().translateFrom(array: jsonBrokerage) else { completion(nil, nil, APIClientError.apiError("Couldn't parse expected fields"))
//                        return }
//                guard let jsonPortfolios = json["totalAmounts"] as? [[String: Any]],
//                    let currencyPortfolios = try? CurrencyPortfolioTranslator().translateFrom(array: jsonPortfolios) else { completion(nil, nil, APIClientError.apiError("Couldn't parse expected fields"))
//                        return }
//                
//                completion(brokerageAccounts, currencyPortfolios, nil)
//            case let .failure(error):
//                completion(nil, nil, error)
//                
//            }
//        }
        Alamofire.request("https://us-central1-nobamus-f315a.cloudfunctions.net/closestUsers?latitude=\(latitude)&longitude=\(longitude)&country=\(NSLocale.current.regionCode)").responseJSON { response in
            guard let userIds = response.result.value as? [String] else { return }
            for id in userIds {
                DatabaseManager.getUser(with: id)
            }
        }
    }
}
