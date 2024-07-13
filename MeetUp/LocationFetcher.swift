//
//  LocationFetcher.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 12/07/2024.
//

import CoreLocation
import Foundation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
