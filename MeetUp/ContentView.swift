//
//  ContentView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State private var name: String = ""
    @State private var beginImage: CIImage?
    
    let context = CIContext()
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.allPeople.isEmpty {
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let picture = viewModel.processedImage {
                            picture
                                .resizable()
                                .scaledToFit()
                    } else {
                        ContentUnavailableView("No Pictures Yet", systemImage: "photo.badge.plus", description: Text("Tap to add your first picture"))
                    }
                }
                .onChange(of: viewModel.selectedItem) {
                    Task {
                        viewModel.processedImage = try await viewModel.selectedItem?.loadTransferable(type: Image.self)
                    }
                }
                if viewModel.processedImage != nil {
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
                ForEach(viewModel.allPeople, id: \.id) { item in
                    // TODO: More Code Later
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

