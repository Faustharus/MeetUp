//
//  AddView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 07/07/2024.
//

import PhotosUI
import SwiftUI

struct AddView: View {
 
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    @State private var isOpen: Bool = false
    
    let locationFetcher: LocationFetcher
    var onSave: (Person) -> Void
    
    init(locationFetcher: LocationFetcher, onSave: @escaping (Person) -> Void) {
        self.locationFetcher = locationFetcher
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel())
    }
    
    var body: some View {
        VStack {
            if let picture = viewModel.processedImage {
                picture
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: UIScreen.current!.bounds.width * 0.9, height: UIScreen.current!.bounds.height * 0.5)
                    .padding()
                
                Button("Add") {
                    self.isOpen = true
                }
                .alert("Insert the Name", isPresented: $isOpen) {
                    TextField("Person's Name", text: $viewModel.name)
                        .keyboardType(.default)
                    Button {
                        Task {
                            let newPerson = await viewModel.createNew(location: locationFetcher.lastKnownLocation)
                            onSave(newPerson)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    Button("Cancer", role: .cancel) { viewModel.cancelAdd() }
                }
            } else {
                ContentUnavailableView("No Picture Yet", systemImage: "photo.badge.plus", description: Text("Tap to insert another photo"))
            }
            PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                Text("Another Photo")
            }
            .buttonStyle(.bordered)
        }
        .onChange(of: viewModel.selectedItem, viewModel.loadImage)
    }
}

#Preview {
    AddView(locationFetcher: LocationFetcher(), onSave: { _ in })
}
