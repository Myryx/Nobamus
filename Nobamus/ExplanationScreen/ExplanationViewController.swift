import Foundation
import UIKit

class ExplanationViewController: UIViewController {
    
    var onDismissAction:(() -> Void)?
    
    fileprivate var selfView: ExplanationView {
        return self.view as! ExplanationView
    }
    
    override func loadView() {
        self.view = ExplanationView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfView.customDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ExplanationViewController: ExplanationViewDelegate {
    func gotItTapped() {
        dismiss(animated: true, completion: onDismissAction)
    }
}
