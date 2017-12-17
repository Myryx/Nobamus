//
//  SelfView.swift
//  Created by Yanislav Kononov on 9/30/17.

import Foundation
import UIKit
import SnapKit

class SelfView: UIView {
    
    private let circleTop: CGFloat = 65
    private let circleSize: CGFloat = 80
    
    private let loginStatusTop: CGFloat = 15
    
    private let activityTop: CGFloat = 40
    private let activitySize: CGFloat = 30
    
    private let inputFieldTop: CGFloat = 50
    private let inputFieldHeight: CGFloat = 30
    private let inputFieldSideOffset: CGFloat = 50
    
    private let startButtonTop: CGFloat = 50
    private let startButtonHeight: CGFloat = 30
    private let startButtonWidth: CGFloat = 150
    
    
    fileprivate(set) lazy var tapView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black
        return view
    }()
    
    fileprivate(set) lazy var circleImageView: SpeakersImageView = {
        return SpeakersImageView(frame: CGRect.zero)
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
        inputField.attributedPlaceholder = NSAttributedString(string: localizedStringForKey("Login.Enter Name"), attributes: [NSForegroundColorAttributeName: UIColor.gray])
        inputField.font = UIFont.regularOfSize(20)
        inputField.textColor = .white
        inputField.textAlignment = .center
        inputField.textColor = .gray
        return inputField
    }()
    
    fileprivate(set) lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blackColorWithAlpha(0.5)
        button.layer.cornerRadius = 4.0
        button.setTitleColor(UIColor.nobamusOrange, for: .normal)
        button.setTitle(localizedStringForKey("Login.Start").uppercased(), for: .normal)
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
        addSubview(tapView)
        addSubview(circleImageView)
        addSubview(loginStatusLabel)
        addSubview(startButton)
        addSubview(inputField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        tapView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleImageView.snp.remakeConstraints { make in
            make.size.equalTo(circleSize)
            make.top.equalToSuperview().offset(circleTop)
            make.centerX.equalToSuperview()
        }
        
        loginStatusLabel.snp.remakeConstraints { make in
            make.top.equalTo(circleImageView.snp.bottom).offset(loginStatusTop)
            make.centerX.equalToSuperview()
        }
        
        inputField.snp.remakeConstraints { make in
            make.height.equalTo(inputFieldHeight)
            make.top.equalTo(circleImageView.snp.bottom).offset(inputFieldTop)
            make.left.equalToSuperview().offset(inputFieldSideOffset)
            make.right.equalToSuperview().offset(-inputFieldSideOffset)
        }
        
        startButton.snp.remakeConstraints { make in
            make.height.equalTo(startButtonHeight)
            make.top.equalTo(inputField.snp.bottom).offset(startButtonTop)
            make.width.equalTo(startButtonWidth)
            make.centerX.equalToSuperview()
        }
        super.updateConstraints()
    }
}
