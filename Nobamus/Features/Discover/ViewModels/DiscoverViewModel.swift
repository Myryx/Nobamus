//
// View Model for the discovery screen
//
import Foundation
import CoreLocation

protocol DiscoverViewModelDelegate: class {
    func peopleAroundFetchDidFinish()
    func peopleAroundFetchDidFail()
}

protocol PortfolioViewModelProtocol {
    weak var delegate: DiscoverViewModelDelegate? { get set }
    var people: [Person] { get }
    func getPeople(_ location: CLLocation)
}

class DiscoverViewModel {
    let peoplePortionNumber = 10
    private let service: DiscoverService
    private var locationProvider: LocationProvider
    weak var delegate: DiscoverViewModelDelegate?
    
    init(locationProvider: LocationProvider, service: DiscoverService) {
        self.locationProvider = locationProvider
        self.service = service
        locationProvider.startUpdatingLocation()
    }
    
    func getPeopleAround() -> [Person] {
        
    }
}

extension DiscoverViewModel: LocationProviderDelegate {
    func locationWasFound() {
        getPeopleAround()
    }
}
