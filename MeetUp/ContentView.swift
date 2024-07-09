//
//  ContentView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    
    @State private var isOpen: Bool = false
    
    var body: some View {
        NavigationStack {
            if viewModel.allPeople.isEmpty {
                VStack {
                    PhotosPicker(selection: $viewModel.selectedItem) {
                        if let picture = viewModel.processedImage {
                            picture
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: 400, height: 200)
                                .padding()
                        } else {
                            ContentUnavailableView("No Picture Yet", systemImage: "photo.badge.plus", description: Text("Tap to insert your first photo"))
                        }
                    }
                    .onChange(of: viewModel.selectedItem, viewModel.loadImage)
                    
                    Spacer()
                    
                    if viewModel.processedImage != nil {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 2.5)
                            VStack {
                                TextField("Person's Name", text: $viewModel.name)
                                    .keyboardType(.default)
                                    .padding(.horizontal)
                            }
                        }
                        .frame(width: 300, height: 55)
                        
                        Button {
                            Task {
                                await viewModel.addNewPerson(viewModel.name)
                            }
                        } label: {
                            Text("Save")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .frame(width: 300, height: 55)
                                .background(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.name.count < 3 ? Color.gray.gradient : Color.blue.gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.name.count < 3)
                    }
                    
                }
                .navigationTitle("MeetUp")
            } else {
                List {
                    ForEach(viewModel.allPeople, id: \.id) { person in
                        HStack {
                            if let image = viewModel.imageFromData(person.picture) {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 75)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            Text("\(person.name)")
                        }
                    }
                    .onDelete(perform: viewModel.deletePerson)
                }
                .navigationTitle("MeetUp")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.isOpen = true
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $isOpen) {
                    AddView(onSave: { newPerson in
                        viewModel.allPeople.append(newPerson)
                        viewModel.save()
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
