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
    @State private var isItFirst: Bool = false
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.allPeople.isEmpty {
                    VStack {
                        if let picture = viewModel.processedImage {
                            picture
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: UIScreen.current!.bounds.width * 0.9, height: UIScreen.current!.bounds.height * 0.5)
                                .padding()
                            
                            Button("Add") {
                                self.isItFirst = true
                            }
                            .buttonStyle(.borderedProminent)
                            .alert("Insert the Name", isPresented: $isItFirst) {
                                TextField("Person's Name", text: $viewModel.name)
                                    .keyboardType(.default)
                                Button {
                                    Task {
                                        if let location = locationFetcher.lastKnownLocation {
                                            await viewModel.addNewPerson(viewModel.name, point: location)
                                        }
                                    }
                                } label: {
                                    Text("Save")
                                }
                                Button("Cancel", role: .cancel) { viewModel.cancelAdd() }
                            }
                        } else {
                            ContentUnavailableView("No Picture Yet", systemImage: "photo.badge.plus", description: Text("Tap \(Image(systemName: "plus.circle.fill")) to insert your first photo"))
                        }
                    }
                    .onChange(of: viewModel.selectedItem, viewModel.loadImage)
                } else {
                    List {
                        ForEach(viewModel.allPeople.sorted(), id: \.name) { person in
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
                                        .font(.headline)
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deletePerson)
                    }
                }
            }
            .onAppear(perform: locationFetcher.start)
            .navigationTitle("MeetUp")
            .navigationDestination(for: Person.self) { person in
                DetailView(person: person)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.allPeople.isEmpty {
                        Button {
                            self.isOpen = true
                        } label: {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                    } else {
                        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isOpen) {
                AddView(locationFetcher: locationFetcher) { person in
                    viewModel.allPeople.append(person)
                    viewModel.save()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
