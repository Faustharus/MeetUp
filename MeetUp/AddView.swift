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
    
    @FocusState var isInputValid: Bool
    
    @State private var viewModel: ViewModel
    
    let locationFetcher: LocationFetcher
    var onSave: (Person) -> Void
    
    init(locationFetcher: LocationFetcher, onSave: @escaping (Person) -> Void) {
        self.locationFetcher = locationFetcher
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel())
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 3)
                VStack {
                    TextField("Person's Name", text: $viewModel.name)
                        .keyboardType(.default)
                        .focused($isInputValid)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button {
                                    self.isInputValid = false
                                } label: {
                                    Label("Done", systemImage: "keyboard.chevron.compact.down")
                                }
                                
                                Spacer()
                                
                                Button {
                                    self.viewModel.name = ""
                                } label: {
                                    Label("Reset", systemImage: "eraser.line.dashed")
                                }
                            }
                        }
                }
                .padding(.horizontal)
            }
            .frame(width: 300, height: 55)
            
            PhotosPicker(selection: $viewModel.selectedItem) {
                if let picture = viewModel.processedImage {
                    picture
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 400, height: 200)
                        .padding()
                } else {
                    ContentUnavailableView("Select your photo", systemImage: "photo.badge.plus", description: Text("Tap to add the person's photo"))
                        .frame(width: 400, height: 200)
                }
            }
            .onChange(of: viewModel.selectedItem, viewModel.loadImage)
            
            Button("Save") {
                Task {
                    let newPerson = await viewModel.createNew(location: locationFetcher.lastKnownLocation)
                    onSave(newPerson)
                    dismiss()
                }
                
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AddView(locationFetcher: LocationFetcher(), onSave: { _ in })
}
