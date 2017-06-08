//
//  DiscoverVIew.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

class DiscoverView: UIView {
    
    private let collectionViewBorders: CGFloat = 5
    private let cellPartOfFrame: CGFloat = 0.38
    
    private var cellSize : CGSize! {
        get {
            let side = UIScreen.main.bounds.width * 0.38
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
        return collectionView
    }()
    
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
        backgroundImage.snp.makeConstraints({ make in
            make.edges.equalTo(self)
        })
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(self).offset(self.collectionViewBorders)
            make.bottom.equalTo(self).offset(-self.collectionViewBorders)
            make.left.equalTo(self).offset(self.collectionViewBorders)
            make.right.equalTo(self).offset(-self.collectionViewBorders)
        })
        super.updateConstraints()
    }
    
}
