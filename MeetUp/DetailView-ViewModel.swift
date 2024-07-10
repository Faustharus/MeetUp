//
//  DetailView-ViewModel.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 10/07/2024.
//

import PhotosUI
import SwiftUI

extension DetailView {
    @Observable
    class ViewModel {
        var processedImage: Image?
        var selectedItem: PhotosPickerItem?
        
        var beginImage: CIImage?
        let context = CIContext()
        
        let savePeople = SavedPersons.savePeople
        
        func imageFromData(_ data: Data?) -> Image? {
            guard let data = data, let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        }
    }
}
