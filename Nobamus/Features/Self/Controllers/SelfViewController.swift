//
//  Copyright © 2017 Yanislav Kononov. All rights reserved.

import Foundation
import UIKit
import StoreKit

class SelfViewController: UIViewController {
    
    private let canProceed: Bool = false // all AppleMusic permissions are OK and we can use the service
    fileprivate var didLoginToFirebase = false
    fileprivate var didLoginToAppleMusic = false
    private var shouldShowOnboarding = false
    
    var provider: LoginAppleMusicProvider
    
    var firebaseService = LoginFirebaseService()
    
    // MARK: - initialization
    
    init (_ provider: LoginAppleMusicProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        self.provider.delegate = self
        firebaseService.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var selfView: SelfView {
        return self.view as! SelfView
    }
    
    override func loadView() {
        self.view = SelfView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = UserDefaults.standard.value(forKey: "userName") as? String {
            selfView.inputField.isHidden = true
            selfView.startButton.isHidden = true
            selfView.circleImageView.play()
            selfView.loginStatusLabel.isHidden = false
            firebaseService.signInAnonymouslyFireBase(with: name)
            provider.appleMusicRequestPermission()
        } else {
            shouldShowOnboarding = true
        }
        hideKeyboardWhenTappedAround()
        configureViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureViews() {
        selfView.startButton.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        selfView.inputField.delegate = self
    }
    
    func acceptButtonPressed() {
        guard let text = selfView.inputField.text else {
            selfView.inputField.attributedPlaceholder = NSAttributedString(string: localizedStringForKey("Login.FillInYourName"), attributes: [NSForegroundColorAttributeName: UIColor.red])
//            selfView.endEditing(true)
            return
        }
        if (text.characters.count > 0) {
            selfView.circleImageView.play()
            selfView.loginStatusLabel.isHidden = false
            DispatchQueue.global().async {
                self.firebaseService.signInAnonymouslyFireBase(with: text)
                self.provider.appleMusicRequestPermission()
            }
        } else {
            selfView.inputField.attributedPlaceholder = NSAttributedString(string: localizedStringForKey("Login.FillInYourName"), attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
    }
    
    fileprivate func openAppSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    fileprivate func proceed() {
        DispatchQueue.main.async {
            let service = DiscoverService()
            let locationProvider = LocationProvider()
            let viewModel = DiscoverViewModel(locationProvider: locationProvider, service: service)
            locationProvider.delegate = viewModel
            let controller = DiscoverViewController(viewModel: viewModel)
            self.selfView.circleImageView.stop()
            if self.shouldShowOnboarding == true {
                let onboardingController = ExplanationViewController()
                onboardingController.onDismissAction = { [weak self] in
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
                self.present(onboardingController, animated: true, completion: nil)
            } else {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension SelfViewController: FirebaseLoginDelegate {
    func successfulFirebaseLogin() {
        didLoginToFirebase = true
        if didLoginToAppleMusic {
            proceed()
        }
    }
}

extension SelfViewController: AppleMusicLoginDelegate {
    func successfulLogin() {
        didLoginToAppleMusic = true
        if didLoginToFirebase {
            proceed()
        }
    }
    
    func loginFailed(reason: SKCloudServiceAuthorizationStatus){
        switch reason {
        case .authorized:
            return
        case .denied:
            openAppSettings()
        case .notDetermined:
            break
        case .restricted:
            let alert = UIAlertController(title: "The access is restricted", message: "Seems like your device is prohibited from using Apple Music on it", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func cannotPlayback() {
        print("cannotPlayback")
    }
}

extension SelfViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selfView.inputField.resignFirstResponder()
        return true
    }
}
