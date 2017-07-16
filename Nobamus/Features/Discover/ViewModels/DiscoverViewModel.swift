//
// View Model for the discovery screen
//
import Foundation
import CoreLocation

protocol DiscoverViewModelDelegate: class {
    func peopleAroundFetchDidFinish()
    func peopleAroundFetchDidFail(_ errorMessage: String)
}

protocol DiscoverViewModelProtocol {
    weak var delegate: DiscoverViewModelDelegate? { get set }
    var loadingOperations: [IndexPath : PersonLoadOperation] { get set }
    var shouldUpdatePeople: Bool { get set }
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
    private var locationProvider: LocationProvider
    private let loadingQueue = OperationQueue()
    weak var delegate: DiscoverViewModelDelegate?
    var loadingOperations: [IndexPath : PersonLoadOperation] = [:]
    var peopleAroundIdentifiers: [String] = []
    var visibleIndices: [IndexPath] = []
    var shouldUpdatePeople: Bool = true
    
    init(locationProvider: LocationProvider, service: DiscoverService) {
        self.locationProvider = locationProvider
        self.service = service
        locationProvider.startUpdatingLocation()
        MusicProvider.delegate = self
        MusicProvider.setup()
    }
    
    func numberOfItems() -> Int {
        return peopleAroundIdentifiers.count
    }
    
    func configureCell(_ cell: DiscoverCell, at indexPath: IndexPath) {
        guard let person = loadingOperations[indexPath]?.person else { return }
        print("Person name: \(person.name)")
        cell.personName = person.name
        cell.distance = indexPath.row
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
    }
    
    func stopPersonLoading(at indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        if let dataLoader = getLoadOperation(for: indexPath), let person = dataLoader.person {
            MusicProvider.playTrack(person.track)
        } else {
            guard let dataLoader = getLoadOperation(for: indexPath) else { return }
            dataLoader.loadingCompleteHandler = {
                if let track = dataLoader.person?.track {
                    MusicProvider.playTrack(track)
                    DatabaseManager.updateUserTrack(track: track)
                }
            }
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
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
    func personalTrackHasChanged(to track: Track) {
        DatabaseManager.updateUserTrack(track: track)
    }
}

extension DiscoverViewModel: LocationProviderDelegate {
    func locationWasFound(_ location: CLLocation) {
        getPeopleAround(location)
    }
}
