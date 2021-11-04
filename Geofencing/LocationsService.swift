//
//  LocationsService.swift
//  Geofencing
//
//  Created by Jeffrey Thompson on 11/3/21.
//

import Foundation
import CoreLocation

protocol LocationsServiceDelegate {
    func locationsService(_ service: LocationsService, didEnterRegion region: CLRegion)
    func locationsService(_ service: LocationsService, didExitRegion region: CLRegion)
    func locationsService(_ service: LocationsService, didStartMonitoringFor region: CLRegion)
    func locationsServiceDidChangeAuthorization(_ service: LocationsService, authorization: LocationsAuthState)
}

enum LocationsAuthState: Codable {
    case full, inUse, denied, undefined
    
    var description: String {
        switch self {
        case .full:
            return "full permissions"
        case .inUse:
            return "Some features may not be available if locations services are only allowed while in use."
        case .denied:
            return "Some features may not be avaialble if locations services are denied."
        case .undefined:
            return "There was an error implementing locations services. This may limit some features."
        }
    }
}

class LocationsService: NSObject {

    static public let userDefaultsKey = "userAuthorizesLocationServices"
    private let manager = CLLocationManager()
    public var delegate: LocationsServiceDelegate?
    private var idHolder: String = ""
    @Published public var currentCoordinate = CLLocation(latitude: 0, longitude: 0)
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    public func ensurePermissions() {
        manager.requestAlwaysAuthorization()
    }
    
    public func updateCurrentCoordinate() {
        manager.requestLocation()
    }
    
    public func beginMonitoring(location: CLLocation, rangeInMeters: Int, identifier: String) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            let radius = CLLocationDistance(rangeInMeters)
            let region = CLCircularRegion(
                center: location.coordinate,
                radius: radius,
                identifier: identifier)
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            manager.startMonitoring(for: region)
        }
    }
    
    public func beginMonitoringCurrentLocation(identifier: String) {
        idHolder = identifier
        manager.requestLocation()
    }
    
    public func stopMonitoringLocation(identifier: String) {
        manager.monitoredRegions.forEach { region in
            if region.identifier == identifier {
                manager.stopMonitoring(for: region)
            }
        }
    }

}

extension LocationsService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Just entered region: \(region.identifier)")
        delegate?.locationsService(self, didEnterRegion: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Just exited region: \(region.identifier)")
        delegate?.locationsService(self, didExitRegion: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Added monitored region: \(region.identifier)")
        delegate?.locationsService(self, didStartMonitoringFor: region)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("CLLocationManager started location updates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("CLLocation manager did update locations:")
        if let location = locations.first {
            if idHolder.isEmpty {
                currentCoordinate = location
            } else {
                beginMonitoring(location: location, rangeInMeters: 300, identifier: idHolder)
                idHolder = ""
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("CLLocation manager did visit... :\(visit.description)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocation manager didFailWithError: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            if let encoded = try? PropertyListEncoder().encode(LocationsAuthState.full) {
                UserDefaults.standard.set(encoded, forKey: LocationsService.userDefaultsKey)
            }
            delegate?.locationsServiceDidChangeAuthorization(self, authorization: LocationsAuthState.full)
        case .authorizedWhenInUse:
            if let encoded = try? PropertyListEncoder().encode(LocationsAuthState.inUse) {
                UserDefaults.standard.set(encoded, forKey: LocationsService.userDefaultsKey)
            }
            delegate?.locationsServiceDidChangeAuthorization(self, authorization: LocationsAuthState.inUse)
        case .denied:
            if let encoded = try? PropertyListEncoder().encode(LocationsAuthState.denied) {
                UserDefaults.standard.set(encoded, forKey: LocationsService.userDefaultsKey)
            }
            delegate?.locationsServiceDidChangeAuthorization(self, authorization: LocationsAuthState.denied)
        case .notDetermined, .restricted:
            if let encoded = try? PropertyListEncoder().encode(LocationsAuthState.undefined) {
                UserDefaults.standard.set(encoded, forKey: LocationsService.userDefaultsKey)
            }
            delegate?.locationsServiceDidChangeAuthorization(self, authorization: LocationsAuthState.undefined)
        @unknown default:
            break
        }
    }
    
}
