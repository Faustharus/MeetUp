//
//  Person.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import Foundation

struct Person: Identifiable, Codable, Comparable {
    var id = UUID()
    var name: String
    var picture: Data
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        return lhs.name < rhs.name
    }
}
