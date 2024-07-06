//
//  EditView.swift
//  MeetUp
//
//  Created by Damien Chailloleau on 04/07/2024.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    
    init() {
        _viewModel = State(initialValue: ViewModel())
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    EditView()
}
