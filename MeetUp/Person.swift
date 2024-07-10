//
//  Person.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import SwiftUI

struct Person: Identifiable, Codable, Comparable, Hashable {
    var id = UUID()
    var name: String
    var picture: Data?
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        return lhs.name < rhs.name
    }
    
    #if DEBUG
    static let example = Person(name: "Jane Doe")
    #endif
}
