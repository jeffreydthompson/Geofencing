//
//  GeofencingApp.swift
//  Geofencing
//
//  Created by Jeffrey Thompson on 11/2/21.
//

import SwiftUI
import UIKit

@main
struct GeofencingApp: App {
    
    //@UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationsWrapper: LocationsServiceWrapper())
        }
    }
}
