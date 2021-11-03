//
//  AppDelegate.swift
//  Geofencing
//
//  Created by Jeffrey Thompson on 11/2/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class AppDelegate: NSObject, UIApplicationDelegate {

//    @Published var message = ""
//    @Published var mapCenter = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
    //let clManager = CLLocationManager()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // ...
        
//        if let _ = UserDefaults.standard.object(forKey: LocationsService.userDefaultsKey) as? LocationsAuthState {
//            //They've made their choice
//        } else {
//            LocationsService.ensurePermissions()
//        }
        
        //print("App delegate didFinishLaunchingWithOptions")
        //clManager.delegate = self
        //clManager.requestAlwaysAuthorization()
        
        //clManager.monitoredRegions.forEach { region in
            //print("Monitored region \(region.identifier)")
            //clManager.stopMonitoring(for: region)
        //}

        //clManager.startUpdatingLocation()
        //37.383807, -121.895129
        //add(locationMonitor: CLLocation(latitude: 37.37595272253968, longitude: -121.8028612622263), rangeKm: 100, identifier: "home")
        
        return true
    }
    
//    func add(locationMonitor location: CLLocation, rangeKm: Int, identifier: String) {
//        print("app delegate add")
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//
//            let radius = CLLocationDistance(rangeKm)
//            let region = CLCircularRegion(
//                center: location.coordinate,
//                radius: radius,
//                identifier: identifier)
//            region.notifyOnExit = true
//            region.notifyOnEntry = true
//
//            clManager.startMonitoring(for: region)
//        }
//    }
//
//    func requestLocation() {
//        clManager.requestLocation()
//    }
}

/*extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Just entered region: \(region.identifier)")
        message = "Just entered region: \(region.identifier)"
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Just exited region: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Added monitored region: \(region.identifier)")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("CLLocationManager started location updates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("CLLocation manager did update locations:")
        locations.forEach { location in
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            mapCenter = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("CLLocation manager did visit... :\(visit.description)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocation manager didFailWithError: \(error)")
    }
}
*/
