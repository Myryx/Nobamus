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
    func getPeopleAround(_ location: CLLocation)
}

class DiscoverViewModel: DiscoverViewModelProtocol {
    private let service: DiscoverService
    private var locationProvider: LocationProvider
    weak var delegate: DiscoverViewModelDelegate?
    var loadingOperations: [IndexPath : PersonLoadOperation] = [:]
    var peopleAroundIdentifiers: [String] = []
    
    init(locationProvider: LocationProvider, service: DiscoverService) {
        self.locationProvider = locationProvider
        self.service = service
        locationProvider.startUpdatingLocation()
    }
    
    func getPeopleAround(_ location: CLLocation) {
        service.getIdsOfUsersAround(location: location, country: User.sharedInstance.country, completion: { [unowned self] (identifiers, error) in
            if let identifiers = identifiers, error == nil {
                self.peopleAroundIdentifiers = identifiers
                
            } else if let error = error {
                self.delegate?.peopleAroundFetchDidFail(error.localizedDescription)
            }
            
        })
    }
}

extension DiscoverViewModel: LocationProviderDelegate {
    func locationWasFound(_ location: CLLocation) {
        getPeopleAround(location)
    }
}
