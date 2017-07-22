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
        addSubview(avatarImage)
        addSubview(coverView)
        addSubview(nameLabel)
//        addSubview(distanceLabel)
        addSubview(playIconImageView)
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
    
    func enableCellAppearance() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nameLabel.alpha = 1.0
            self.distanceLabel.alpha = 1.0
            self.coverView.alpha = 1.0
        })
    }
    
    func disableCellAppearance() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nameLabel.alpha = 0
            self.distanceLabel.alpha = 0
            self.coverView.alpha = 0
        })
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        distanceLabel.text = ""
        playIconImageView.isHidden = true
        disableCellAppearance()
    }
    
    override func updateConstraints() {
        avatarImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
//        playIconImageView.snp.remakeConstraints { make in
//            make.size.equalTo(playIconSize)
//            make.center.equalToSuperview()
//        }
        nameLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        playIconImageView.snp.remakeConstraints { make in
            make.size.equalTo(playIconSize)
            make.right.equalToSuperview().offset(-distanceRight)
            make.bottom.equalToSuperview().offset(-distanceBottom)
        }
        super.updateConstraints()
    }
}
