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
    
    @State private var name: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var processedImage: Image?
    @FocusState var isInputValid: Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 3)
                VStack {
                    TextField("Person's Name", text: $name)
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
                                    self.name = ""
                                } label: {
                                    Label("Reset", systemImage: "eraser.line.dashed")
                                }
                            }
                        }
                }
                .padding(.horizontal)
            }
            .frame(width: 300, height: 55)
            
            PhotosPicker(selection: $selectedItem) {
                if let picture = processedImage {
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
            .onChange(of: selectedItem) {
                Task {
                    processedImage = try await selectedItem?.loadTransferable(type: Image.self)
                }
            }
            
            Button("Save") {
                // TODO: More Code to Come
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AddView()
}
