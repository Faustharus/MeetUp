//
//  ContentView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 01/07/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @Environment(\.editMode) var editMode
    
    @State private var viewModel = ViewModel()
    @State private var isOpen: Bool = false
    
    @FocusState var isInputValid: Bool
    
    let locationFetcher = LocationFetcher()
    
    /** Change the View to switch between the ContentUnavailableView and the '+' Button in the toolbar -> By having only one ViewModel for ContentView and AddView - Removing the Extension ? */
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.allPeople.isEmpty {
                    Button {
                        self.isOpen = true
                    } label: {
                        ContentUnavailableView("No Picture Yet", systemImage: "photo.badge.plus", description: Text("Tap to insert your first photo"))
                    }
                } else {
//                    EmptyView()
                    List {
                        ForEach(viewModel.allPeople.sorted()) { person in
                            NavigationLink(value: person) {
                                HStack {
                                    if let image = viewModel.imageFromData(person.picture) {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                    
                                    Text("\(person.name)")
                                        .font(.headline)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            if editMode?.wrappedValue == .active {
                                viewModel.deletePerson(at: indexSet)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Person.self, destination: { person in
                DetailView(person: person)
            })
            .navigationTitle("MeetUp")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        locationFetcher.start()
                    } label: {
                        Label("Tracking", systemImage: "paperplane.circle.fill")
                    }
                    
                    Spacer()
                    
                    Button {
                        self.isOpen = true
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isOpen) {
                AddView(locationFetcher: locationFetcher) { newPerson in
                    viewModel.allPeople.append(newPerson)
                    viewModel.save()
                }
            }
        }
    }
    
//    var body: some View {
//        NavigationStack {
//            if viewModel.allPeople.isEmpty {
//                VStack {
//                    PhotosPicker(selection: $viewModel.selectedItem) {
//                        if let picture = viewModel.processedImage {
//                            picture
//                                .resizable()
//                                .scaledToFit()
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .frame(width: 300, height: 100)
//                                .padding()
//                        } else {
//                            ContentUnavailableView("No Picture Yet", systemImage: "photo.badge.plus", description: Text("Tap to insert your first photo"))
//                        }
//                    }
//                    .onChange(of: viewModel.selectedItem, viewModel.loadImage)
//                    
//                    Spacer()
//                    
//                    VStack {
//                        if viewModel.processedImage != nil {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(.black, lineWidth: 2.5)
//                                VStack {
//                                    TextField("Person's Name", text: $viewModel.name)
//                                        .keyboardType(.default)
//                                        .focused($isInputValid)
//                                        .toolbar {
//                                            ToolbarItemGroup(placement: .keyboard) {
//                                                Button {
//                                                    self.isInputValid = false
//                                                } label: {
//                                                    Label("Done", systemImage: "keyboard.chevron.compact.down")
//                                                }
//                                                
//                                                Spacer()
//                                                
//                                                Button {
//                                                    self.viewModel.name = ""
//                                                } label: {
//                                                    Label("Reset", systemImage: "eraser.line.dashed")
//                                                }
//                                            }
//                                        }
//                                        .padding(.horizontal)
//                                }
//                            }
//                            .frame(width: 300, height: 55)
//                            
//                            Button {
//                                Task {
//                                    if let location = locationFetcher.lastKnownLocation {
//                                        await viewModel.addNewPerson(viewModel.name, point: location)
//                                    }
//                                }
//                            } label: {
//                                Text("Save")
//                                    .font(.title.bold())
//                                    .foregroundStyle(.white)
//                                    .frame(width: 300, height: 55)
//                                    .background(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.name.count < 3 ? Color.gray.gradient : Color.blue.gradient)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                            .disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.name.count < 3)
//                            
//                            Button {
//                                viewModel.cancelAdd()
//                            } label: {
//                                Text("Cancel")
//                                    .font(.title.bold())
//                                    .foregroundStyle(.white)
//                                    .frame(width: 300, height: 55)
//                                    .background(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.name.count < 3 ? Color.gray.gradient : Color.red.gradient)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("MeetUp")
//                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Start Tracking Location") {
//                            locationFetcher.start()
//                        }
//                    }
//                }
//            } else {
//                List {
//                    ForEach(viewModel.allPeople.sorted(), id: \.name) { person in
//                        NavigationLink(value: person) {
//                            HStack {
//                                if let image = viewModel.imageFromData(person.picture) {
//                                    image
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 100, height: 75)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                }
//                                Text("\(person.name)")
//                            }
//                        }
//                    }
//                    .onDelete { indexSet in
//                        viewModel.deletePerson(at: indexSet)
//                    }
//                }
//                .navigationTitle("MeetUp")
//                .navigationDestination(for: Person.self, destination: { person in
//                    DetailView(person: person)
//                })
//                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button {
//                            self.isOpen = true
//                        } label: {
//                            Label("Add", systemImage: "plus")
//                        }
//                        
//                        Spacer()
//                        
//                        Button("Start Tracking Location") {
//                            locationFetcher.start()
//                        }
//                    }
//                    
//                    ToolbarItem(placement: .topBarLeading) {
//                        EditButton()
//                    }
//                }
//                .sheet(isPresented: $isOpen) {
//                    AddView(locationFetcher: locationFetcher, onSave: { newPerson in
//                        viewModel.allPeople.append(newPerson)
//                        viewModel.save()
//                    })
//                }
//            }
//        }
//    }
}

#Preview {
    ContentView()
}
