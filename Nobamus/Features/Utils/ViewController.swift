
import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditingHideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func endEditingHideKeyboard() {
        view.endEditing(true)
    }
}
