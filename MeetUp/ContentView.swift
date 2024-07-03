//
//  ContentView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var allPeople = [Person]()
    @State private var name: String = ""
    @State private var beginImage: CIImage?
    
    let context = CIContext()
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if allPeople.isEmpty {
            VStack {
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                            processedImage
                                .resizable()
                                .scaledToFit()
                    } else {
                        ContentUnavailableView("No Pictures Yet", systemImage: "photo.badge.plus", description: Text("Tap to add your first picture"))
                    }
                }
                .onChange(of: selectedItem) {
                    Task {
                        processedImage = try await selectedItem?.loadTransferable(type: Image.self)
                    }
                }
                if processedImage != nil {
                    VStack {
                        TextField("Person's Name", text: $name)
                            .keyboardType(.default)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        
                        Button("Save") {
                            // TODO: Save Function
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
        } else {
            List {
                ForEach(allPeople, id: \.id) { item in
                    // TODO: More Code Later
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

