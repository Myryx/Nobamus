//
//  Array extensions
//

import Foundation

extension Array {
    
    func safeObjectAtIndex(_ index: Int) -> Element? {
        var object: Element? = nil
        if index >= 0 && self.count > index {
            object = self[index]
        }
        return object
    }
    
    func safeFirstObject() -> Element? {
        return self.safeObjectAtIndex(0)
    }
    
    func safeLastObject() -> Element? {
        return self.safeObjectAtIndex(self.count - 1)
    }
}
