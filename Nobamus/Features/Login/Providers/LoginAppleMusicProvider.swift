//
//  LoginAppleMusicProvider.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/20/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import StoreKit
import MediaPlayer
import SwiftyJSON

protocol AppleMusicLoginDelegate: class {
    func successfulLogin()
    func loginFailed(reason: SKCloudServiceAuthorizationStatus)
    func cannotPlayback()
}

class LoginAppleMusicProvider {
    
    weak var delegate: AppleMusicLoginDelegate?
    
    func appleMusicRequestPermission() {
        
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized:
            self.proceedIfCanPlayback()
            return
        case .denied:
            appleMusicRequestAuthorization()
        case .notDetermined: // The user hasn't decided yet - so we'll break out of the switch and ask them
            delegate?.loginFailed(reason: .notDetermined)
            break
        case .restricted: // User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied
            delegate?.loginFailed(reason: .restricted)
            return
        }
        appleMusicRequestAuthorization()
    }
    
    private func appleMusicRequestAuthorization() {
        
        SKCloudServiceController.requestAuthorization { status in
            switch status {
            case .authorized: // All good - the user tapped 'OK', so you're clear to move forward and start playing
                self.proceedIfCanPlayback()
                return
            case .denied: // The user tapped 'Don't allow'
                self.delegate?.loginFailed(reason: .denied)
                return
            case .notDetermined: // The user hasn't decided or it's not clear whether they've confirmed or denied
                self.delegate?.loginFailed(reason: .notDetermined)
                
            case .restricted: // User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied
                self.delegate?.loginFailed(reason: .restricted)
            }
        }
    }
    
    private func proceedIfCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities(completionHandler: { (capability:SKCloudServiceCapability, err:Error?) in
            if(capability.contains(SKCloudServiceCapability.musicCatalogPlayback)) {
                self.appleMusicFetchStorefrontRegion()
                self.delegate?.successfulLogin()
            } else {
                self.delegate?.cannotPlayback()
            }
        })
    }
    
    private func appleMusicFetchStorefrontRegion() {
        
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier(completionHandler: { (storefrontId:String?, err:Error?) in
            guard err == nil else {
                self.appleMusicFetchStorefrontRegion()
                return
            }
            
            guard let storefrontId = storefrontId, storefrontId.characters.count >= 6 else {
                print("Handle the error - the callback didn't contain a valid storefrontID.")
                return
            }
            let startIndex = storefrontId.index(storefrontId.startIndex, offsetBy: 0)
            let endIndex = storefrontId.index(storefrontId.startIndex, offsetBy: 5)
            
            let trimmed_id = storefrontId[startIndex...endIndex]
            User.sharedInstance.storeFrondID = Int(trimmed_id)
            print("The user's storefront ID is: \(trimmed_id)")
        })
    }
}
