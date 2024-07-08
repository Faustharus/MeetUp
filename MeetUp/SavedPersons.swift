//
//  SavedPersons.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 08/07/2024.
//

import Foundation

enum SavedPersons {
    static let savePeople = URL.documentsDirectory.appending(path: "savedPeople")
}
