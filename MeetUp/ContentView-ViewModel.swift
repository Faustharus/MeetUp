//
//  ContentView-ViewModel.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 03/07/2024.
//

import PhotosUI
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        var processedImage: Image?
        var selectedItem: PhotosPickerItem?
        var allPeople = [Person]()
        
        let savePeople = URL.documentsDirectory.appending(path: "savedPeople")
        
        init() {
            do {
                let data = try Data(contentsOf: savePeople)
                allPeople = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                allPeople = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(allPeople)
                try data.write(to: savePeople, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addNewPerson(person: Person) {
            Task {
                guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
                let newPerson = Person(name: "New Person", picture: imageData)
            }
        }
    }
}


//func load() {
//    Task {
//        guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
//        guard let inputImage = UIImage(data: imageData) else { return }
//        beginImage = CIImage(image: inputImage)
//        if let beginImage {
//            guard let cgImage = context.createCGImage(beginImage, from: beginImage.extent) else { return }
//            let uiImage = UIImage(cgImage: cgImage)
//            processedImage = Image(uiImage: uiImage)
//        }
//        
//    }
//}
