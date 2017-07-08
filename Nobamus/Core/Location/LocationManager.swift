import Foundation
import CoreLocation
import UIKit

protocol LocationProviderDelegate: class {
    func locationWasFound(_ location: CLLocation)
}

class LocationProvider: NSObject {
    
    fileprivate var location: CLLocation?
    fileprivate var locationManager: CLLocationManager!
    fileprivate var currentBestAccuracy: CLLocationAccuracy!
    fileprivate var isUpdatingLocation: Bool = false
    weak var delegate: LocationProviderDelegate?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 1
        isUpdatingLocation = false
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        isUpdatingLocation = true
    }
    
    fileprivate func updateLocation(location:CLLocation) {
        guard
            location.horizontalAccuracy > 0,
            location.horizontalAccuracy <= 65
        else { return }
        guard isUpdatingLocation == true else { return }
        stopUpdatingLocation()
        storeLocation(location: location)
        delegate?.locationWasFound(location)
    }
    
    private func stopUpdatingLocation() {
        isUpdatingLocation = false
        locationManager.stopUpdatingLocation()
        // and after 60 secs refresh the location
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
            self?.startUpdatingLocation()
        }
    }
    
    private func storeLocation(location: CLLocation) {
        self.location = location
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        User.sharedInstance.latitude = latitude
        User.sharedInstance.longitude = longitude
        DatabaseManager.updateUser(key: "latitude", value: latitude)
        DatabaseManager.updateUser(key: "longitude", value: longitude)
        
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { updateLocation(location: location) }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Promt the user the alert that his location is unaccessible")
    }
}
