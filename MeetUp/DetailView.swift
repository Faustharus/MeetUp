//
//  DetailView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 10/07/2024.
//

import MapKit
import SwiftUI

struct DetailView: View {
    
    @State private var viewModel = ViewModel()
    
    @State private var isMapOpen: Bool = false
    
    let person: Person
    
    var body: some View {
        VStack {
            if let picture = viewModel.imageFromData(person.picture) {
                picture
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: UIScreen.current!.bounds.width * 0.8)
                    .padding()
                
                Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: person.coordinate.latitude, longitude: person.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))) {
                    Annotation("Test", coordinate: person.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                    }
                }
            } else {
                ContentUnavailableView("No Picture", systemImage: "photo.on.rectangle.angled", description: Text("There is no picture to match to the name"))
                    .frame(width: 400, height: 200)
            }
        }
        .navigationTitle(person.name)
    }
}

#Preview {
    DetailView(person: .example)
}
