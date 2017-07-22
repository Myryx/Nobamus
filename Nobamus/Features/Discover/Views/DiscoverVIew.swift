//
// View for displaying cells with people around
//

import Foundation
import UIKit

class DiscoverView: UIView {
    // MARK: - Variables
    private let collectionViewBorders: CGFloat = 5
    private let cellPartOfFrameWidth: CGFloat = 0.38
    private let collectionSideInsetSize: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 20
    private let minimumInteritemSpacing: CGFloat = 20
    
    private let activityTop: CGFloat = 40
    private let activitySize: CGFloat = 30
    
    private let loginStatusTop: CGFloat = 10
    
    private var cellSize : CGSize! {
        get {
            let side = UIScreen.main.bounds.width * cellPartOfFrameWidth
            let size = CGSize(width: side, height: side)
            return size
        }
    }
    
    fileprivate(set) lazy var backgroundImage: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = UIImage(named: "login_background")
        return view
    }()
    
    fileprivate(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = .whiteLarge
        return activity
    }()
    
    fileprivate(set) lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularOfSize(17)
        label.text = localizedStringForKey("Discover.LookingForPeopleAround")
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = false
        label.isHidden = true
        return label
    }()
    
    fileprivate(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsetsMake(0, self.collectionSideInsetSize, 0, self.collectionSideInsetSize)
        return collectionView
    }()
    
    fileprivate(set) lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return refreshControl
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(loginStatusLabel)
        guard let collectionViewLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        collectionViewLayout.itemSize = cellSize
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = minimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionView.addSubview(refreshControl)
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
        collectionView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(collectionViewBorders)
            make.bottom.equalToSuperview().offset(-collectionViewBorders)
            make.left.equalToSuperview().offset(collectionViewBorders)
            make.right.equalToSuperview().offset(-collectionViewBorders)
        }
        super.updateConstraints()
    }
}
