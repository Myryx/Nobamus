//
//  ExplanationView.swift
//  Nobamus

import Foundation
import UIKit
import SnapKit

protocol ExplanationViewDelegate: class {
    func gotItTapped()
}

class ExplanationView: UIView {
    weak var customDelegate: ExplanationViewDelegate?
    
    fileprivate(set) lazy var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(17)
        label.text = localizedStringForKey("Explanation.Text")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    fileprivate(set) lazy var gotItButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blackColorWithAlpha(0.5)
        button.setTitleColor(UIColor.nobamusOrange, for: .normal)
        button.setTitle(localizedStringForKey("Explanation.GotIt").uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.mediumOfSize(16)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(gotItTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(explanationLabel)
        addSubview(gotItButton)
        makeConstraints()
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func gotItTapped() {
        customDelegate?.gotItTapped()
    }
    
    func makeConstraints() {
        explanationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(20)
        }
        gotItButton.snp.makeConstraints { make in
            make.top.equalTo(explanationLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }
}
