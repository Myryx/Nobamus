//
//  Cell for displaying information about person and for playing the music this person is playing
//

import Foundation
import UIKit

class DiscoverCell: UICollectionViewCell {
    
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
    
    var distanceBottom: CGFloat = 20 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var nameLabelBorder: CGFloat = 10 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var coverColor: UIColor = UIColor.blackColorWithAlpha(0.3) {
        didSet {
            coverView.backgroundColor = coverColor
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
    
    fileprivate(set) lazy var avatarImage: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        return view
    }()
    
    fileprivate(set) lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColorWithAlpha(0.3)
        return view
    }()
    
    fileprivate(set) lazy var playIconImageView: UIImageView = {
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
        addSubview(playIconImageView)
        addSubview(nameLabel)
        addSubview(distanceLabel)
        backgroundColor = UIColor.blackColorWithAlpha(0.8)
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
        avatarImage.snp.updateConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        coverView.snp.updateConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        playIconImageView.snp.updateConstraints { make in
            make.size.equalTo(playIconSize)
            make.center.equalTo(snp.center)
        }
        nameLabel.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.right.left.equalToSuperview().offset(nameLabelBorder)
        }
        distanceLabel.snp.updateConstraints { make in
            make.right.equalToSuperview().offset(-distanceRight)
            make.bottom.equalToSuperview().offset(-distanceBottom)
        }
        super.updateConstraints()
    }
}
