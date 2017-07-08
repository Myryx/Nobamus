//
//  ErrorProcessor.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 7/8/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

typealias ErrorAlertHandler = (UIAlertAction) -> Void

protocol ErrorProcessor {
    func presentError(with localizedDescription: String, completion:  ErrorAlertHandler?)
}

extension ErrorProcessor {
    func presentError(with localizedDescription: String, completion: ErrorAlertHandler?) {
        let alertViewController = UIAlertController(title: localizedStringForKey("Error"), message: localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: localizedStringForKey("AlertAction.OK"), style: UIAlertActionStyle.default, handler: completion))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
}

class APIErrorProcessor: ErrorProcessor {
    static let sharedInstance = APIErrorProcessor()
    private init() { }
}
