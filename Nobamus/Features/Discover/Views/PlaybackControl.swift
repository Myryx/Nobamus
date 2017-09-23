//
//  THe blayback control that displays title, artist and play\pause button
//
//  Created by Yanislav Kononov on 7/28/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

protocol PlaybackControlDelegate: class {
    func playbackButtonPressed()
}

enum PlaybackControlState {
    case playing
    case paused
}

class PlaybackControl: UIView {
    // MARK: - Variables
    private let titleLeftOffset: CGFloat = 10
    private let titleRightOffset: CGFloat = 10
    private let titleTopOffset: CGFloat = 10
    private let artistTopOffset: CGFloat = 10
    private let playbackButtonRightOffset: CGFloat = 30
    private let playbackButtonSize: CGFloat = 40
    var state: PlaybackControlState = .paused {
        didSet {
            if state == .paused {
                playbackButton.setImage(UIImage(named: "playback_play"), for: .normal)
            } else {
                playbackButton.setImage(UIImage(named: "playback_pause"), for: .normal)
            }
        }
    }
    weak var delegate: PlaybackControlDelegate?
    var viewModel: PlaybackControlViewModelProtocol? {
        didSet {
            titleLabel.text = viewModel?.title
            artistLabel.text = viewModel?.artist
        }
    }
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(17)
        label.textAlignment = .left
        label.textColor = UIColor.blackColorWithAlpha(0.9)
        return label
    }()
    
    fileprivate(set) lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(17)
        label.textAlignment = .left
        label.textColor = UIColor.whiteColorWithAlpha(0.7)
        return label
    }()
    
    fileprivate(set) lazy var playbackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blackColorWithAlpha(0.5)
        button.setImage(UIImage(named: "playback_pause"), for: .normal)
        button.addTarget(self, action: #selector(playbackButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(playbackButton)
        backgroundColor = UIColor.darkGray
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playbackButtonPressed() {
        switchState()
        delegate?.playbackButtonPressed()
    }
    
    func reset() {
        titleLabel.text = ""
        artistLabel.text = ""
    }
    
    func switchState() {
        if state == .paused {
            state = .playing
        } else {
            state = .paused
        }
    }
    // MARK: - Layout
    
    func makeConstraints() {
        playbackButton.snp.makeConstraints { make in
            make.right.equalTo(-playbackButtonRightOffset)
            make.size.equalTo(playbackButtonSize)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(titleLeftOffset)
            make.right.equalTo(playbackButton).offset(titleRightOffset)
            make.top.equalToSuperview().offset(titleTopOffset)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(titleLeftOffset)
            make.right.equalTo(playbackButton).offset(titleRightOffset)
            make.top.equalTo(titleLabel.snp.bottom).offset(artistTopOffset)
        }
    }
}

