//
//  LoginViewController.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/7/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    
    private let paymentViewHeight: CGFloat = 110.0
    private let hintLabelHeight: CGFloat = 12
    private let cellIdentifier = "p2pCardsListCell"
    
    var viewModel: LoginViewModel? {
        didSet {
//            viewModel?.delegate = self
        }
    }
    
    // MARK: - content view
    fileprivate var loginView: LoginView {
        guard let loginView = view as? LoginView else {
            let newLoginView = LoginView(frame: UIScreen.main.bounds)
            self.view = newLoginView
            return newLoginView
        }
        return loginView
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
    }
    
    func acceptButtonPressed() {
        guard let text = loginView.inputField.text else { return }
        if(text.characters.count > 0) {
            loginView.activityIndicator.startAnimating()
//            AppleMusicManager.setup(callback: successfulAMLogin)
//            AppleMusicManager.appleMusicFetchStorefrontRegion(callback: nil)
//            NetworkManager.signInAnonymouslyFireBase(userName: nameTextField.text!, callback: DatabaseManager.createOrUpdateUser)
        } else {
            loginView.inputField.attributedPlaceholder = NSAttributedString(string: localizedStringForKey("Login.FillInYourName"), attributes: [NSForegroundColorAttributeName : UIColor.red])
        }
    }
}
