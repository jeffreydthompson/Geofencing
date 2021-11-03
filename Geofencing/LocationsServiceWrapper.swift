//
//  LocationsServiceWrapper.swift
//  Geofencing
//
//  Created by Jeffrey Thompson on 11/3/21.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationsServiceWrapper: ObservableObject {
    
    enum State {
        case hasMessage(String)
        case idle
    }

    @Published var state: State = .idle
    @Published var textBoxEntry: String = ""
    @Published var textBoxLatitude: String = ""
    @Published var textBoxLongitude: String = ""
    @Published var currentCoordinate: MKCoordinateRegion
    
    private let locationsService: LocationsService
    
    private var subscriber: AnyCancellable?
    
    init() {
        locationsService = LocationsService()
        locationsService.ensurePermissions()
        locationsService.updateCurrentCoordinate()
        currentCoordinate = MKCoordinateRegion(
            center: locationsService.currentCoordinate.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        setDelegate()
        subscribeToLocation()
    }
    
    func addCurrentLocation() {
        guard !textBoxEntry.isEmpty else {
            state = .hasMessage("Need to enter an identifier")
            return
        }

        locationsService.beginMonitoringCurrentLocation(identifier: textBoxEntry)
        textBoxEntry = ""
    }
    
    func addCustomLocation() {
        guard !textBoxEntry.isEmpty, !textBoxLatitude.isEmpty, !textBoxLongitude.isEmpty else {
            state = .hasMessage("Need to enter in all fields")
            return
        }
        
        var latitude: Double = .nan
        var longitude: Double = .nan
        
        do {
            latitude = try Double(textBoxLatitude, format: .number)
            longitude = try Double(textBoxLongitude, format: .number)
        } catch let error {
            state = .hasMessage(error.localizedDescription)
        }
        
        guard (-90...90).contains(latitude) && (-180...180).contains(longitude) else {
            state = .hasMessage("Enter coordinates within range.  Latitude -90 to 90 degrees.  Longitude -180 to 180 degrees.")
            return
        }

        locationsService.beginMonitoring(location: CLLocation(latitude: latitude, longitude: longitude), rangeInMeters: 300, identifier: textBoxEntry)
        textBoxEntry = ""
        textBoxLatitude = ""
        textBoxLongitude = ""
    }
    
    func dismissMessage() {
        state = .idle
    }
    
    func update() {
        locationsService.updateCurrentCoordinate()
    }
    
    private func setDelegate() {
        locationsService.delegate = self
    }
    
    private func subscribeToLocation() {
        subscriber = locationsService.$currentCoordinate
            .sink(receiveValue: { [weak self] location in
                self?.currentCoordinate = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            })
    }
    
}

extension LocationsServiceWrapper: LocationsServiceDelegate {
    
    func locationsServiceDidChangeAuthorization(_ service: LocationsService, authorization: LocationsAuthState) {
        switch authorization {
        case .full:
            break
        case .inUse, .denied, .undefined:
            state = .hasMessage(authorization.description)
        }
    }
    
    func locationsService(_ service: LocationsService, didEnterRegion region: CLRegion) {
        state = .hasMessage("Just entered \(region.identifier)")
    }
    
    func locationsService(_ service: LocationsService, didExitRegion region: CLRegion) {
        state = .hasMessage("Just entered \(region.identifier)")
    }
    
    func locationsService(_ service: LocationsService, didStartMonitoringFor region: CLRegion) {
        state = .hasMessage("Added \(region.identifier) to monitored regions.")
    }
    
}
