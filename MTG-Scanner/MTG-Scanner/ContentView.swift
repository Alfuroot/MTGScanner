//
//  ScannerView.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 11/12/21.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    var body: some View {
        TabView{
            
            RealScannerView()
                .tabItem {
                Image(systemName: "camera.fill")
                Text("Scan")
                }
            CardListView()
                .tabItem {
                        Image(systemName: "list.dash")
                        Text("Card List")
                   }
           }
            
        }
    
}

