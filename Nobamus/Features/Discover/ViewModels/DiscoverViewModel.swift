//
// View Model for the discovery screen
//
import Foundation
import UIKit
import CoreLocation

protocol DiscoverViewModelDelegate: class {
    func peopleAroundFetchDidFinish()
    func peopleAroundFetchDidFail(_ errorMessage: String)
    func updateCellAppearance(isPlaying: Bool, indexPath: IndexPath)
    func updateOverallAppearance(isPlaying: Bool)
    func playedTrackInMusicApp()
}

protocol DiscoverViewModelProtocol {
    weak var delegate: DiscoverViewModelDelegate? { get set }
    var loadingOperations: [IndexPath : PersonLoadOperation] { get set }
    var locationProvider: LocationProvider { get }
    var shouldUpdatePeople: Bool { get set }
    var lastSelectedCellIndexPath: IndexPath? { get set }
    func numberOfItems() -> Int
    func configureCell(_ cell: DiscoverCell, at indexPath: IndexPath)
    func getPeopleAround(_ location: CLLocation)
    func preparePersonLoading(at indexPath: IndexPath)
    func managePersonLoading(at indexPath: IndexPath, completion: (() -> Void)?)
    func stopPersonLoading(at indexPath: IndexPath)
    func didSelectItem(at indexPath: IndexPath)
    func fefreshData()
}

class DiscoverViewModel: DiscoverViewModelProtocol {
    private let service: DiscoverService
    var locationProvider: LocationProvider
    private let loadingQueue = OperationQueue()
    weak var delegate: DiscoverViewModelDelegate?
    var lastSelectedCellIndexPath: IndexPath?
    var loadingOperations: [IndexPath : PersonLoadOperation] = [:]
    var peopleAroundIdentifiers: [String] = []
    var visibleIndices: [IndexPath] = []
    var shouldUpdatePeople: Bool = true
    
    init(locationProvider: LocationProvider, service: DiscoverService) {
        self.locationProvider = locationProvider
        self.service = service
        MusicProvider.delegate = self
        MusicProvider.setup()
    }
    
    func numberOfItems() -> Int {
        return peopleAroundIdentifiers.count
    }
    
    func configureCell(_ cell: DiscoverCell, at indexPath: IndexPath) {
        guard let person = loadingOperations[indexPath]?.person else { return }
        cell.personName = person.name
        cell.distance = indexPath.row
        if indexPath == lastSelectedCellIndexPath && MusicProvider.isPlaying == true && MusicProvider.playbackState.wherePlayedLastTime == .inApp {
            cell.setIsPlaying(isPlaying: true)
        }
        cell.enableCellAppearance()
    }
    
    func getPeopleAround(_ location: CLLocation) {
        service.getIdsOfUsersAround(location: location, country: User.sharedInstance.country, completion: { [unowned self] (identifiers, error) in
            if let identifiers = identifiers, error == nil {
                self.peopleAroundIdentifiers = identifiers.filter({$0 != User.sharedInstance.uniqueID})
                if self.shouldUpdatePeople == true {
                    self.delegate?.peopleAroundFetchDidFinish()
                    self.shouldUpdatePeople = false
                }
            } else if let error = error {
                self.delegate?.peopleAroundFetchDidFail(error.localizedDescription)
            }
        })
    }
    
    func preparePersonLoading(at indexPath: IndexPath) {
        guard loadingOperations[indexPath] != nil else { return }
        if let dataLoader = getLoadOperation(for: indexPath) {
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
    }
    
    func managePersonLoading(at indexPath: IndexPath, completion: (() -> Void)? ) {
        // If the operation has already been created
        if let dataLoader = loadingOperations[indexPath] {
            // Find out if it has already finished
            if dataLoader.person != nil, let completion = completion {
                completion()
            } else if let completion = completion {
                dataLoader.loadingCompleteHandler = completion
            }
        } else {
            guard let dataLoader = getLoadOperation(for: indexPath) else { return }
            dataLoader.loadingCompleteHandler = completion
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
        guard let personId = peopleAroundIdentifiers.safeObjectAtIndex(indexPath.row) else { return }
        DatabaseManager.observePersonForTrackChange(id: personId, at: indexPath, completion: { [weak self] (track, indexPath) in
            if let dataLoader = self?.loadingOperations[indexPath], let newTrack = track {
                dataLoader.person?.track = newTrack
            }
        })
    }
    
    func stopPersonLoading(at indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
            guard let personId = peopleAroundIdentifiers.safeObjectAtIndex(indexPath.row) else { return }
            DatabaseManager.detachObserver(for: personId)
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        if indexPath == lastSelectedCellIndexPath { // if we tapped on the same cell again
            if MusicProvider.playbackState.wherePlayedLastTime == .inMusicApp {
                delegate?.updateOverallAppearance(isPlaying: true)
                delegate?.updateCellAppearance(isPlaying: true, indexPath: indexPath)
                MusicProvider.playLastDiscoverTrack()
            } else {
                if MusicProvider.isPlaying == true {
                    delegate?.updateOverallAppearance(isPlaying: false)
                    delegate?.updateCellAppearance(isPlaying: false, indexPath: indexPath)
                    MusicProvider.pausePlaying()
                } else {
                    delegate?.updateOverallAppearance(isPlaying: true)
                    delegate?.updateCellAppearance(isPlaying: true, indexPath: indexPath)
                    MusicProvider.continuePlaying()
                }
            }
            
        } else { // we tapped on a different cell so we can play the music
            if let lastSelectedCellIndexPath = self.lastSelectedCellIndexPath {
                self.delegate?.updateCellAppearance(isPlaying: false, indexPath: lastSelectedCellIndexPath)
            }
            self.lastSelectedCellIndexPath = indexPath
            if let dataLoader = getLoadOperation(for: indexPath), let person = dataLoader.person {
                delegate?.updateOverallAppearance(isPlaying: true)
                delegate?.updateCellAppearance(isPlaying: true, indexPath: indexPath)
                MusicProvider.playTrack(person.track)
            } else {
                guard let dataLoader = getLoadOperation(for: indexPath) else { return }
                dataLoader.loadingCompleteHandler = { [unowned self] in
                    if let track = dataLoader.person?.track {
                        self.delegate?.updateOverallAppearance(isPlaying: true)
                        self.delegate?.updateCellAppearance(isPlaying: true, indexPath: indexPath)
                        MusicProvider.playTrack(track)
                        DatabaseManager.updateUserTrack(track: track)
                    }
                }
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func fefreshData() {
        self.peopleAroundIdentifiers = []
        guard let latitude = User.sharedInstance.latitude, let longitude = User.sharedInstance.longitude else {
            locationProvider.startUpdatingLocation()
            return
        }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        getPeopleAround(location)
    }
    
    private func getLoadOperation(for indexPath: IndexPath) -> PersonLoadOperation? {
        guard let personId = peopleAroundIdentifiers.safeObjectAtIndex(indexPath.row) else {
            return nil
        }
        return PersonLoadOperation(personId)
    }
}

extension DiscoverViewModel: MusicProviderDelegate {
    func personalTrackHasBeenUpdated(to track: Track) { // should be valid only if in background
        DatabaseManager.updateUserTrack(track: track)
        guard UIApplication.shared.applicationState == .background else { return }
        if MusicProvider.playbackState.isPlaying == true {
            MusicProvider.playbackState.isPlaying = false
            delegate?.playedTrackInMusicApp()
        }
    }
}

extension DiscoverViewModel: LocationProviderDelegate {
    func locationWasFound(_ location: CLLocation) {
        getPeopleAround(location)
    }
}
