//
//  Extension for fonts so we can quickly get the one needed
//

import Foundation
import UIKit

public extension UIFont {
    class func regularOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightRegular)
    }
    class func mediumOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightMedium)
    }
    class func boldOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
    }
    class func lightOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightLight)
    }
    class func semiboldOfSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
    }
}
