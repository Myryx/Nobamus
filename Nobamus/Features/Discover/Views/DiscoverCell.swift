//
//  Cell for displaying information about person and for playing the music this person is playing
//

import Foundation
import UIKit

class DiscoverCell: UICollectionViewCell {
    
    let offlineOverlayAlpha: CGFloat = 0.7
    
    var playIconSize: CGFloat = 15 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var distanceRight: CGFloat = 5 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var distanceBottom: CGFloat = 5 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var nameLabelBorder: CGFloat = 10 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var personName: String = "" {
        didSet {
            nameLabel.text = personName
        }
    }
    
    var distance: Int = 0 {
        didSet {
            distanceLabel.text = String(distance)
        }
    }
    
    static let reuseIdentifier = "DiscoverCell"
    let progressManager = DiscoverProgressManager()
    
    fileprivate(set) lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return UIView()
    }()
    
    fileprivate(set) lazy var avatarImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    fileprivate(set) lazy var progressView: KDCircularProgress = {
        let view = KDCircularProgress(frame: CGRect.zero)
        view.startAngle = -90
        view.progressThickness = 0.1
        view.clockwise = true
        view.roundedCorners = false
        view.glowAmount = 0
        view.set(colors: UIColor.nobamusOrange)
        return view
    }()
    
    fileprivate(set) lazy var speakersImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        if let image1 = UIImage(named: "rings-animation_1"),
        let image2 = UIImage(named: "rings-animation_2"),
        let image3 = UIImage(named: "rings-animation_3") {
            view.animationImages = [image1, image2, image3]
            view.animationDuration = 1
            view.image = image1
        }
        view.tintColor = UIColor.white
        return view
    }()
    
    fileprivate(set) lazy var offlineOverlay: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black
        return view
    }()

    fileprivate(set) lazy var playIconImageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = UIImage(named: "icon_Play")
        view.isHidden = true
        return view
    }()
    
    fileprivate(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(20)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.alpha = 0
        return label
    }()
    
    fileprivate(set) lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(18)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainView)
//        mainView.addSubview(avatarImageView)
        mainView.addSubview(playIconImageView)
        mainView.addSubview(speakersImageView)
        mainView.addSubview(progressView)
        mainView.addSubview(offlineOverlay)
        addSubview(nameLabel)
        progressManager.delegate = self
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    func configure(image: UIImage, name: String, distance: Int) {
//        avatarImageView.image = image
        nameLabel.text = name
        distanceLabel.text = String(distance)
    }
    
    func enableCellAppearance() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nameLabel.alpha = 1.0
            self.distanceLabel.alpha = 1.0
            self.progressView.alpha = 1.0
            self.speakersImageView.alpha = 1.0
//            self.avatarImageView.alpha = 1.0
            
        })
    }
    
    func disableCellAppearance() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nameLabel.alpha = 0
            self.distanceLabel.alpha = 0
            self.progressView.alpha = 0
            self.speakersImageView.alpha = 0
//            self.avatarImageView.alpha = 0
        })
    }
    
    func setIsPlaying(isPlaying: Bool) {
        if isPlaying {
            speakersImageView.startAnimating()
        } else {
            speakersImageView.stopAnimating()
        }
    }
    
    func resetProgress() {
        progressView.angle = 0
    }
    
    private func startProgress(startingTime: Double, overallTime: Double) {
        progressManager.startingTime = startingTime
        progressManager.overallTime = overallTime
        progressManager.startProgress()
    }
    
    private func stopProgress() {
        progressManager.stopProgress()
    }
    
    func setOnline() {
        isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.offlineOverlay.alpha = 0
        })
    }
    
    func setOffline() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.offlineOverlay.alpha = self.offlineOverlayAlpha
        })
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        distanceLabel.text = ""
        playIconImageView.isHidden = true
        offlineOverlay.alpha = 0
        disableCellAppearance()
    }
    
    func makeConstraints() {
        
        mainView.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-30)
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
//        avatarImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        offlineOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        speakersImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        playIconImageView.snp.makeConstraints { make in
            make.size.equalTo(playIconSize)
            make.right.equalToSuperview().offset(-distanceRight)
            make.bottom.equalToSuperview().offset(-distanceBottom)
        }
//        avatarImageView.roundImage(imageSize: self.frame.width)
    }
}

extension DiscoverCell: DiscoverProgressManagerDelegate {
    func moveProgressBar(by angle: Double) {
        progressView.angle = progressView.angle + angle
    }
    
    func setProgressBar(to angle: Double) {
        progressView.angle = angle
    }
}
