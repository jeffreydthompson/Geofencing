//
//  ContentView.swift
//  Geofencing
//
//  Created by Jeffrey Thompson on 11/2/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    @ObservedObject var locationsWrapper: LocationsServiceWrapper
    
    var body: some View {
        Group {
            switch locationsWrapper.state {
            case .hasMessage(let message):
                VStack {
                    Text(message)
                        .font(.title)
                        .padding()
                    Button {
                        locationsWrapper.dismissMessage()
                    } label: {
                        Text("Dismiss")
                    }
                }
            case .idle:
                
                NavigationView {
                    VStack {
                        Map(coordinateRegion: $locationsWrapper.currentCoordinate)
                            .frame(height: 300)

                        HStack {
                            Button {
                                locationsWrapper.update()
                            } label: {
                                Text("\(Image(systemName: "location"))")
                            }
                            .padding()
                        
                            NavigationLink("Add current location") {
                                AddCurrentLocationView(locationsWrapper: locationsWrapper)
                                    .padding()
                            }
                        }
                        .padding()
                        
                        NavigationLink("Add custom location") {
                            AddCustomLocationView(locationsWrapper: locationsWrapper)
                                .padding()
                        }
                    }
                }
            }
        }
        
    }
}

struct AddCurrentLocationView: View {
    
    @ObservedObject var locationsWrapper: LocationsServiceWrapper
    
    var body: some View {
        VStack {
            TextField(text: $locationsWrapper.textBoxEntry, prompt: Text("Enter a location identifier.")) {
                Text("Enter an identifier")
            }
            
            Button {
                locationsWrapper.addCurrentLocation()
            } label: {
                Text("Add location")
            }
            .padding()
        }
    }
    
}

struct AddCustomLocationView: View {
    
    @ObservedObject var locationsWrapper: LocationsServiceWrapper
    
    var body: some View {
        VStack {
            TextField(text: $locationsWrapper.textBoxEntry, prompt: Text("Enter a location identifier.")) {
                Text("Enter an identifier")
            }
            
            TextField(text: $locationsWrapper.textBoxLatitude, prompt: Text("Enter latitude.")) {
                Text("Enter latitude")
            }
            .keyboardType(.numbersAndPunctuation)
            
            TextField(text: $locationsWrapper.textBoxLongitude, prompt: Text("Enter longitude.")) {
                Text("Enter longitude")
            }
            .keyboardType(.numbersAndPunctuation)
            
            Button {
                locationsWrapper.addCustomLocation()
            } label: {
                Text("Add location")
            }
            .padding()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locationsWrapper: LocationsServiceWrapper())
    }
}
