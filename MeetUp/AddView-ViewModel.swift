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
        var people: Person?
        
        var beginImage: CIImage?
        let context = CIContext()
        
        let savePeople = URL.documentsDirectory.appending(path: "savedPeople")
        
        init() {
            
        }
    }
}
