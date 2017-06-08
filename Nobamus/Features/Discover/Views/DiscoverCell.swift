//
//  DiscoverCell.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

class DiscoverCell: UICollectionViewCell{
    
    private let playIconSize: CGFloat = 15
    
    private let distanceHeight: CGFloat = 10
    private let distanceRight: CGFloat = 5
    private let distanceBottom: CGFloat = 20
    
    private let nameLabelHeight: CGFloat = 25
    private let nameLabelBorder: CGFloat = 10
    
    static let reuseIdentifier = "DiscoverCell"
    
    fileprivate(set) lazy var avatarImage: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        return view
    }()
    
    fileprivate(set) lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColorWithAlpha(0.3)
        return view
    }()
    
    fileprivate(set) lazy var playIconImage: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = UIImage(named: "")
        return view
    }()
    
    fileprivate(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(20)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    fileprivate(set) lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(10)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(avatarImage)
        addSubview(coverView)
        addSubview(playIconImage)
        addSubview(nameLabel)
        addSubview(distanceLabel)
        self.backgroundColor = UIColor.blackColorWithAlpha(0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    func configure(image: UIImage, name: String, distance: Int) {
        avatarImage.image = image
        nameLabel.text = name
        distanceLabel.text = String(distance)
    }
    
    override func updateConstraints() {
        avatarImage.snp.makeConstraints({ make in
            make.top.bottom.right.left.equalTo(self)
        })
        coverView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(self)
        }
        playIconImage.snp.makeConstraints { make in
            make.size.equalTo(self.playIconSize)
            make.center.equalTo(self.snp.center)
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(self.nameLabelHeight)
            make.right.left.equalTo(self).offset(self.nameLabelBorder)
        }
        distanceLabel.snp.makeConstraints { make in
            make.height.equalTo(self.distanceHeight)
            make.right.equalTo(self.snp.right).offset(-distanceRight)
            make.bottom.equalTo(self.snp.bottom).offset(-distanceBottom)
        }
        super.updateConstraints()
    }
}
