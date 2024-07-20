//
//  ContentView-ViewModel.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 03/07/2024.
//

import CoreImage
import PhotosUI
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        var processedImage: Image?
        var selectedItem: PhotosPickerItem?
        
        var name: String = ""
        var allPeople = [Person]()
        var people: Person?
        
        var beginImage: CIImage?
        let context = CIContext()
        
        let savePeople = SavedPersons.savePeople
        
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
        
        func loadImage() {
            Task {
                guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
                guard let inputImage = UIImage(data: imageData) else { return }
                beginImage = CIImage(image: inputImage)
                if let beginImage {
                    guard let cgImage = context.createCGImage(beginImage, from: beginImage.extent) else { return }
                    let uiImage = UIImage(cgImage: cgImage)
                    processedImage = Image(uiImage: uiImage)
                }
            }
        }
        
        func addNewPerson(_ name: String, point: CLLocationCoordinate2D) async {
            let imageData = try? await selectedItem?.loadTransferable(type: Data.self)
            
            let newPerson = Person(name: name, picture: imageData, latitude: point.latitude, longitude: point.longitude)
            allPeople.append(newPerson)
            save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cancelAdd()
            }
        }
        
        func cancelAdd() {
            selectedItem = nil
            processedImage = nil
            name = ""
        }
        
        func imageFromData(_ data: Data?) -> Image? {
            guard let data = data, let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        }
        
        func deletePerson(at offsets: IndexSet) {
            allPeople.remove(atOffsets: offsets)
            save()
        }
    }
}
