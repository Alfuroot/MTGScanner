//
//  TextPreviewView.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 16/12/21.
//


import SwiftUI

struct TextPreviewView: View {
    var text: String
    
    var body: some View {
        VStack {
            ScrollView {
                Text(text)
                    .font(.body)
                    .padding()
            }
        }
    }
}

struct TextPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        TextPreviewView(text: "")
    }
}
