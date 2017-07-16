//
//  ViewController that manages interaction with user on other users discovery
//

import Foundation
import UIKit

class DiscoverViewController: UIViewController {
    
    var cellSize : CGSize! {
        get {
            let side = UIScreen.main.bounds.width * 0.38
            let size = CGSize(width: side, height: side)
            return size
        }
    }
    
    var viewModel: DiscoverViewModelProtocol
    
    fileprivate var discoverView: DiscoverView {
        return view as! DiscoverView
    }
    
    lazy var collectionView: UICollectionView? = {
        return self.discoverView.collectionView
    }()
    
    init(viewModel: DiscoverViewModelProtocol) {
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
        collectionView?.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverCell.reuseIdentifier)
        discoverView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshData() {
        viewModel.shouldUpdatePeople = true
        viewModel.fefreshData()
    }
    
}

extension DiscoverViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.preparePersonLoading(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.stopPersonLoading(at: indexPath)
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DiscoverCell else { return }
        
        let updateCellClosure: () -> () = { [unowned self] _ in
            self.viewModel.configureCell(cell, at: indexPath)
            self.viewModel.loadingOperations.removeValue(forKey: indexPath)
        }
        self.viewModel.managePersonLoading(at: indexPath, completion: updateCellClosure)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.stopPersonLoading(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension DiscoverViewController: DiscoverViewModelDelegate {
    func peopleAroundFetchDidFinish() {
        collectionView?.reloadData()
        if discoverView.refreshControl.isRefreshing {
           discoverView.refreshControl.endRefreshing()
        }
    }
    func peopleAroundFetchDidFail(_ errorMessage: String) {
        APIErrorProcessor.sharedInstance.presentError(with: errorMessage, completion: nil)
    }
}
