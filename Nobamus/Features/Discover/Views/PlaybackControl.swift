//
//  Classical view with album icon, title of the song and play/pause button
//
//  Created by Yanislav Kononov on 7/28/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

protocol PlaybackControlDelegate: class {
    func playbackButtonPressed()
}

class PlaybackControl: UIView {
    // MARK: - Variables
    private let albumIconLeftOffset: CGFloat = 10
    private let albumIconSize: CGFloat = 40
    private let titleLeftOffset: CGFloat = 10
    private let titleRightOffset: CGFloat = 10
    private let playbackButtonRightOffset: CGFloat = 20
    private let playbackButtonSize: CGFloat = 40
    
    weak var delegate: PlaybackControlDelegate?
    
    fileprivate(set) lazy var albumIconImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.backgroundColor = UIColor.blackColorWithAlpha(0.3)
        return view
    }()
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(17)
        label.textAlignment = .left
        label.textColor = UIColor.blackColorWithAlpha(0.9)
        return label
    }()
    
    fileprivate(set) lazy var playbackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blackColorWithAlpha(0.5)
        button.layer.cornerRadius = 2.0
        button.setImage(UIImage(named: "playback_pause"), for: .normal)
        button.addTarget(self, action: #selector(playbackButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(albumIconImageView)
        addSubview(titleLabel)
        addSubview(playbackButton)
        backgroundColor = UIColor.darkGray
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playbackButtonPressed() {
        delegate?.playbackButtonPressed()
    }
    
    func configure(albumImageURL: String, title: String) {
        
    }
    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    func makeConstraints() {
        albumIconImageView.snp.makeConstraints { make in
            make.size.equalTo(albumIconSize)
            make.left.equalToSuperview().offset(albumIconLeftOffset)
            make.centerY.equalToSuperview()
        }
        
        playbackButton.snp.makeConstraints { make in
            make.right.equalTo(-playbackButtonRightOffset)
            make.size.equalTo(playbackButtonSize)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(albumIconImageView).offset(titleLeftOffset)
            make.right.equalTo(playbackButton).offset(titleRightOffset)
            make.centerY.equalToSuperview()
        }
    }
}

