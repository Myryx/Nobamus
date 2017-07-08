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
    
    fileprivate(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsetsMake(0, self.collectionSideInsetSize, 0, self.collectionSideInsetSize)
        return collectionView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        addSubview(collectionView)
        guard let collectionViewLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        collectionViewLayout.itemSize = cellSize
        collectionViewLayout.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
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
