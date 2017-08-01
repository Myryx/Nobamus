//
//  ViewController that manages interaction with user on other users discovery
//

import Foundation
import UIKit
import MediaPlayer

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
        let view = DiscoverView(frame: UIScreen.main.bounds)
        view.playbackControl.delegate = self
        self.view = view
        collectionView?.dataSource = self
        collectionView?.prefetchDataSource = self
        collectionView?.delegate = self
        collectionView?.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverCell.reuseIdentifier)
        discoverView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.locationProvider.startUpdatingLocation()
        discoverView.activityIndicator.startAnimating()
        discoverView.loginStatusLabel.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlaybackControlState(_:)), name: NSNotification.Name(rawValue: DiscoverTrackUpdatedNotificationName), object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshData() {
        viewModel.shouldUpdatePeople = true
        viewModel.fefreshData()
    }
    
    func updatePlaybackControlState(_ notification: Notification) {
        
        guard let songTitle = MusicProvider.currentDiscoverTrack?.title else { return }
        
        let artSize = CGSize(width: discoverView.playbackControl.albumIconSize, height: discoverView.playbackControl.albumIconSize)
        var playbackControlVM: PlaybackControlViewModel?
        var image: UIImage?
        if let itemArtwork = MusicProvider.playbackState.playbackItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            image = itemArtwork.image(at: artSize)
            if image == nil {
                image = itemArtwork.image(at: itemArtwork.bounds.size)
            }
        }
        playbackControlVM = PlaybackControlViewModel(image: image, title: songTitle)
        discoverView.playbackControl.viewModel = playbackControlVM
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
        }
        self.viewModel.managePersonLoading(at: indexPath, completion: updateCellClosure)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DiscoverCell else { return }
        if viewModel.lastSelectedCellIndexPath == indexPath && MusicProvider.isPlaying {
            cell.setIsPlaying(isPlaying: false)
        }
        viewModel.stopPersonLoading(at: indexPath)
        
        
//        cell.progressManager.startProgress()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.didSelectItem(at: indexPath)
            self.discoverView.showPlaybackControl()
        }
    }
}

extension DiscoverViewController: DiscoverViewModelDelegate {
    func peopleAroundFetchDidFinish() {
        collectionView?.reloadData()
        if discoverView.refreshControl.isRefreshing {
           discoverView.refreshControl.endRefreshing()
        }
        discoverView.activityIndicator.stopAnimating()
        discoverView.loginStatusLabel.isHidden = true
    }
    
    func peopleAroundFetchDidFail(_ errorMessage: String) {
        discoverView.activityIndicator.stopAnimating()
        discoverView.loginStatusLabel.isHidden = true
        APIErrorProcessor.sharedInstance.presentError(with: errorMessage, completion: nil)
    }
    
    func updateCellAppearance(isPlaying: Bool, indexPath: IndexPath) {
        guard let cell = self.discoverView.collectionView.cellForItem(at: indexPath) as? DiscoverCell else { return }
        cell.setIsPlaying(isPlaying: isPlaying)
    }
    
    func playedTrackInMusicApp() {
        discoverView.hidePlaybackControl()
        guard let indexPath = viewModel.lastSelectedCellIndexPath else { return }
        updateCellAppearance(isPlaying: false, indexPath: indexPath)
    }
    
    func updateOverallAppearance(isPlaying: Bool) {
        if isPlaying == true {
            discoverView.playbackControl.state = .playing
        } else {
            discoverView.playbackControl.state = .paused
        }
    }
    
    func updateCellAppearance(with person: Person, indexPath: IndexPath) {
        guard let cell = self.discoverView.collectionView.cellForItem(at: indexPath) as? DiscoverCell else { return }
        cell.progressManager.setStartingProgressPosition(startingTime: person.playbackTime, overallTime: person.overallPlaybackTime)
        if person.isPlaying {
            cell.progressManager.startProgress()
        } else {
            cell.progressManager.stopProgress()
        }
    }
    
}

extension DiscoverViewController: PlaybackControlDelegate {
    func playbackButtonPressed() {
        MusicProvider.controlPlaybackPressed()
        guard let indexPath = viewModel.lastSelectedCellIndexPath else { return }
        updateCellAppearance(isPlaying: MusicProvider.isPlaying, indexPath: indexPath)
    }
}
