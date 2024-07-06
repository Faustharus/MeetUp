//
//  ContentView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
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
                .onChange(of: viewModel.selectedItem, viewModel.loadImage) //{
//                    Task {
//                        viewModel.processedImage = try await viewModel.selectedItem?.loadTransferable(type: Image.self)
//                    }
                //}
                if viewModel.processedImage != nil {
                    VStack {
                        TextField("Person's Name", text: $viewModel.name)
                            .keyboardType(.default)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        
                        Button("Save") {
                            // TODO: Save Function
                            Task {
                                await viewModel.addNewPerson(viewModel.name)
                            }
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
                    HStack {
                        if let image = viewModel.imageFromData(item.picture) {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Text("\(item.name)")
                    }
                    
                }
            }
        }
    }
    
//    func loadImage() {
//        Task {
//            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
//            guard let inputImage = UIImage(data: imageData) else { return }
//            beginImage = CIImage(image: inputImage)
//            if let beginImage {
//                guard let cgImage = context.createCGImage(beginImage, from: beginImage.extent) else { return }
//                let uiImage = UIImage(cgImage: cgImage)
//                processedImage = Image(uiImage: uiImage)
//            }
//        }
//    }
    
}

#Preview {
    ContentView()
}

/** Sélectionner une photo, Cliquer sur 'Save' déclenche un .sheet où il est demander d'immédiatement enregistrer un nom. Si Annuler, la photo ne s'enregistre pas ; sinon, Cliquer sur 'Confirm'.  */
