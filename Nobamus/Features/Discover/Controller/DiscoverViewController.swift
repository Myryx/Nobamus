//
//  DiscoverViewController.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/21/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewController: UIViewController {
    
    fileprivate let reuseIdentifier = "DiscoverCell"
    
    var cellSize : CGSize! {
        get {
            let side = UIScreen.main.bounds.width * 0.38
            let size = CGSize(width: side, height: side)
            return size
        }
    }
    
    var viewModel: DiscoverViewModel
    
    fileprivate var discoverView: DiscoverView {
        return view as! DiscoverView
    }
    
    lazy var collectionView: UICollectionView? = {
        return self.discoverView.collectionView
    }()
    
    init(viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        self.view = DiscoverView(frame: UIScreen.main.bounds)
        collectionView?.dataSource = self
        collectionView?.prefetchDataSource = self
        collectionView?.delegate = self
        collectionView?.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView?.register(DiscoverCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

extension DiscoverViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension DiscoverViewController: DiscoverViewModelDelegate {
    func peopleAroundFetchDidFinish() {
        print("Did finith fetch")
    }
    func peopleAroundFetchDidFail(_ errorMessage: String) {
        APIErrorProcessor.sharedInstance.presentError(with: errorMessage, completion: nil)
    }
}
