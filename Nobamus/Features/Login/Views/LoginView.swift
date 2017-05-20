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
    private let titleTop: CGFloat = 5
    
    private let activityTop: CGFloat = 20
    private let activitySize: CGFloat = 40
    
    private let inputFieldTop: CGFloat = 20
    private let inputFieldHeight: CGFloat = 100
    private let inputFieldRight: CGFloat = 30
    private let inputFieldLeft: CGFloat = 30
    
    private let acceptButtonTop: CGFloat = 20
    private let acceptButtonHeight: CGFloat = 14
    private let acceptButtonWidth: CGFloat = 100
    
    
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
    
    fileprivate(set) lazy var inputField: UITextField = {
        let inputField = UITextField()
        inputField.placeholder = localizedStringForKey("Your Name")
        inputField.font = UIFont.regularOfSize(20)
        inputField.textAlignment = .center
        inputField.textColor = UIColor.white
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
//        addSubview(backgroundImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.size.equalTo(self.activitySize)
            make.top.equalTo(self).offset(self.activityTop)
            make.centerX.equalTo(self)
        }
        backgroundImage.snp.makeConstraints({ make in
            make.top.bottom.right.left.equalTo(self)
        })
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(self.titleHeight)
            make.top.equalTo(self.activityIndicator.snp.bottom).offset(self.titleTop)
            make.centerX.equalTo(self)
        }
        inputField.snp.makeConstraints { make in
            make.height.equalTo(self.inputFieldHeight)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.inputFieldTop)
            make.right.equalTo(self.inputFieldRight)
            make.left.equalTo(self.inputFieldLeft)
        }
        acceptButton.snp.makeConstraints { make in
            make.height.equalTo(self.acceptButtonHeight)
            make.top.equalTo(self.inputField.snp.bottom).offset(self.acceptButtonTop)
            make.width.equalTo(self.acceptButtonWidth)
        }
        super.updateConstraints()
    }

}
