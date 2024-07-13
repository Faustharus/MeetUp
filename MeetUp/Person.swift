//
//  Person.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import MapKit
import SwiftUI

struct Person: Identifiable, Codable, Comparable, Hashable {
    var id = UUID()
    var name: String
    var picture: Data?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        return lhs.name < rhs.name
    }
    
    #if DEBUG
    static let example = Person(name: "Jane Doe", latitude: 43.7, longitude: 7.25)
    #endif
}
