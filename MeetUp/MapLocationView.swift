//
//  MapLocationView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 13/07/2024.
//

import MapKit
import SwiftUI

struct MapLocationView: View {
    @Environment(\.dismiss) var dismiss
    
    let locationTest: Person?
    
    var body: some View {
        VStack {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .font(.title3.bold())
            .foregroundStyle(.white)
            .frame(width: UIScreen.current!.bounds.width * 0.3, height: UIScreen.current!.bounds.height * 0.05)
            .background(Color.blue.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            Map() {
                Annotation("Test", coordinate: locationTest!.coordinate) {
                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundStyle(.red)
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(.circle)
                }
            }
        }
        .frame(width: UIScreen.current!.bounds.width, height: UIScreen.current!.bounds.height * 0.85)
    }
}

#Preview {
    MapLocationView(locationTest: .example)
}
