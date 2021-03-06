//
//  Color.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/20/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    class func whiteColorWithAlpha(_ alpha: CGFloat) -> UIColor {
        return UIColor.init(white: 1.0, alpha: alpha)
    }
    class func blackColorWithAlpha(_ alpha: CGFloat) -> UIColor {
        return UIColor.init(white: 0.0, alpha: alpha)
    }
    class func grayColorWithAlpha(_ alpha: CGFloat) -> UIColor {
        return UIColor.lightGray
    }
    
    static var nobamusOrange: UIColor {
        return self.init(red: 230/255.0, green: 82/255.0, blue: 28/255.0, alpha: 1.0)
    }
}
