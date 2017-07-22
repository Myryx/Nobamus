//
//  LoginView.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/20/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoginView: UIView {
    
    private let titleHeight: CGFloat = 30
    private let titleTop: CGFloat = 20
    
    private let loginStatusTop: CGFloat = 10
    
    private let activityTop: CGFloat = 40
    private let activitySize: CGFloat = 30
    
    private let inputFieldTop: CGFloat = 150
    private let inputFieldHeight: CGFloat = 30
    private let inputFieldSideOffset: CGFloat = 50
    
    private let acceptButtonTop: CGFloat = 50
    private let acceptButtonHeight: CGFloat = 30
    private let acceptButtonWidth: CGFloat = 150
    
    
    fileprivate(set) lazy var backgroundImage: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = UIImage(named: "login_background")
        return view
    }()
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nobamus"
        label.font = UIFont.regularOfSize(34)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    fileprivate(set) lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(17)
        label.text = localizedStringForKey("Login.WeAreLoggingYouIn")
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = false
        label.isHidden = true
        return label
    }()
    
    fileprivate(set) lazy var inputField: UITextField = {
        let inputField = UITextField()
        inputField.placeholder = localizedStringForKey("Your Name")
        inputField.font = UIFont.regularOfSize(20)
        inputField.textAlignment = .center
        inputField.textColor = UIColor.white
        inputField.backgroundColor = UIColor.whiteColorWithAlpha(10)
        return inputField
    }()
    
    fileprivate(set) lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blackColorWithAlpha(0.5)
        button.layer.cornerRadius = 4.0
        button.setTitleColor(UIColor.whiteColorWithAlpha(0.9), for: .normal)
        button.setTitle(localizedStringForKey("Accept"), for: .normal)
        button.titleLabel?.font = UIFont.mediumOfSize(16)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    fileprivate(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = .whiteLarge
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        addSubview(activityIndicator)
        addSubview(titleLabel)
        addSubview(inputField)
        addSubview(acceptButton)
        addSubview(loginStatusLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        activityIndicator.snp.remakeConstraints { make in
            make.size.equalTo(activitySize)
            make.top.equalToSuperview().offset(activityTop)
            make.centerX.equalToSuperview()
        }
        loginStatusLabel.snp.remakeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(loginStatusTop)
            make.centerX.equalToSuperview()
        }
        backgroundImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.remakeConstraints { make in
            make.height.equalTo(titleHeight)
            make.top.equalTo(loginStatusLabel.snp.bottom).offset(titleTop)
            make.centerX.equalToSuperview()
        }
        inputField.snp.remakeConstraints { make in
            make.height.equalTo(inputFieldHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(inputFieldTop)
            make.left.equalToSuperview().offset(inputFieldSideOffset)
            make.right.equalToSuperview().offset(-inputFieldSideOffset)
        }
        acceptButton.snp.remakeConstraints { make in
            make.height.equalTo(acceptButtonHeight)
            make.top.equalTo(inputField.snp.bottom).offset(acceptButtonTop)
            make.width.equalTo(acceptButtonWidth)
            make.centerX.equalToSuperview()
        }
        super.updateConstraints()
    }
}
