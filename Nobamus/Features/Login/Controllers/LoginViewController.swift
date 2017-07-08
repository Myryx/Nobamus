//
//  LoginViewController.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/7/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class LoginViewController: UIViewController{
    
    private let canProceed: Bool = false // all AppleMusic permissions are OK and we can use the service
    
    var viewModel: LoginViewModel? {
        didSet {
//            viewModel?.delegate = self
        }
    }
    var provider: LoginAppleMusicProvider!
    
    // MARK: - initialization
    
    init (_ provider: LoginAppleMusicProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        self.provider.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var loginView: LoginView {
        guard let view = view as? LoginView else {
            let loginView = LoginView(frame: UIScreen.main.bounds)
            self.view = loginView
            return loginView
        }
        return view
    }
    
    override func loadView() {
        self.view = LoginView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        loginView.acceptButton.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        self.view.addGestureRecognizer(tapGR)
        loginView.inputField.delegate = self
    }
    
    func acceptButtonPressed() {
        guard let text = loginView.inputField.text else { return }
        if (text.characters.count > 0) {
            loginView.activityIndicator.startAnimating()
            provider?.appleMusicRequestPermission()
            LoginFirebaseService.signInAnonymouslyFireBase(with: text)
        } else {
            loginView.inputField.attributedPlaceholder = NSAttributedString(string: localizedStringForKey("Login.FillInYourName"), attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
    }
    
    func tappedOnView() {
        loginView.inputField.resignFirstResponder()
    }
    
    fileprivate func openAppSettings() {
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension LoginViewController: AppleMusicLoginDelegate {
    func successfulLogin() {
//        loginView.activityIndicator.stopAnimating()
//        let controller = DiscoverViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginView.inputField.resignFirstResponder()
        return true
    }
}
