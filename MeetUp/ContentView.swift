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
    
    let locationFetcher = LocationFetcher()
    
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
                                .frame(width: 300, height: 100)
                                .padding()
                        } else {
                            ContentUnavailableView("No Picture Yet", systemImage: "photo.badge.plus", description: Text("Tap to insert your first photo"))
                        }
                    }
                    .onChange(of: viewModel.selectedItem, viewModel.loadImage)
                    
                    Spacer()
                    
                    VStack {
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
                                    if let location = locationFetcher.lastKnownLocation {
                                        await viewModel.addNewPerson(viewModel.name, point: location)
                                    }
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
                            
                            Button {
                                viewModel.cancelAdd()
                            } label: {
                                Text("Cancel")
                                    .font(.title.bold())
                                    .foregroundStyle(.white)
                                    .frame(width: 300, height: 55)
                                    .background(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.name.count < 3 ? Color.gray.gradient : Color.red.gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    //.frame(width: UIScreen.current!.bounds.width * 0.9, height: UIScreen.current!.bounds.height * 0.05)
                }
                .navigationTitle("MeetUp")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Start Tracking Location") {
                            locationFetcher.start()
                        }
                    }
                }
            } else {
                List {
                    ForEach(viewModel.allPeople.sorted(), id: \.id) { person in
                        NavigationLink(value: person) {
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
                        
                    }
                    .onDelete(perform: viewModel.deletePerson)
                }
                .navigationTitle("MeetUp")
                .navigationDestination(for: Person.self, destination: { person in
                    DetailView(person: person)
                })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.isOpen = true
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        
                        Spacer()
                        
                        Button("Start Tracking Location") {
                            locationFetcher.start()
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
