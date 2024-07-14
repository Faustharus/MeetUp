//
//  AddView-ViewModel.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 07/07/2024.
//

import CoreImage
import PhotosUI
import SwiftUI

extension AddView {
    @Observable
    class ViewModel {
        var processedImage: Image?
        var selectedItem: PhotosPickerItem?
        
        var name: String = ""
        
        var beginImage: CIImage?
        let context = CIContext()
        
        let savePeople = SavedPersons.savePeople

        func createNew(point: CLLocationCoordinate2D) async -> Person {
            let imageData = try? await selectedItem?.loadTransferable(type: Data.self)
            let newPerson = Person(name: name, picture: imageData, latitude: point.latitude, longitude: point.longitude)
            return newPerson
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
    }
}
