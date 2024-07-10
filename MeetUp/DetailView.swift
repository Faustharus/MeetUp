//
//  DetailView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 10/07/2024.
//

import SwiftUI

struct DetailView: View {
    
    @State private var viewModel = ViewModel()
    
    let person: Person
    
    var body: some View {
        VStack {
            if let picture = viewModel.imageFromData(person.picture) {
                picture
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 400, height: 200)
                    .padding()
            } else {
                ContentUnavailableView("No Picture", systemImage: "photo.on.rectangle.angled", description: Text("There is no picture to match to the name"))
                    .frame(width: 400, height: 200)
            }
               
            Text(person.name)
                .font(.title.bold().italic())
        }
    }
}

#Preview {
    DetailView(person: .example)
}
