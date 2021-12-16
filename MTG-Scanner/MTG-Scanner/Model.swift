//
//  Model.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 16/12/21.
//

import Foundation

class TextItem: Identifiable {
    var id: String
    var text: String = ""
    
    init() {
        id = UUID().uuidString
    }
}


class RecognizedContent: ObservableObject {
    @Published var items = [TextItem]()
}
