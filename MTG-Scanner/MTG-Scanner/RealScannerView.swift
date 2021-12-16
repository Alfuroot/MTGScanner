//
//  RealScannerView.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 16/12/21.
//

import SwiftUI

struct RealScannerView: View {
    @ObservedObject var recognizedContent = RecognizedContent()
    @State private var showScanner = false
    @State private var isRecognizing = false
    @State private var results = [ResultCard]()
    @State private var search: String = "https://api.scryfall.com/cards/search?order=eur&q=name%3D"
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ForEach(recognizedContent.items, id: \.id) { textItem in
                    GeometryReader{geometry in
                        NavigationView{
                            
                            List(results, id: \.id) { card in
                                if ((card.card_faces?.isEmpty) == nil){
                                    Section{
                                        NavigationLink (destination: CardView(card: card)) {
                                            HStack{
                                                AsyncImage(url: card.image_uris?["small"], content: {image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: (geometry.size.width)*0.15, height: geometry.size.height*0.20)
                                                },
                                                           placeholder: {
                                                    ProgressView()
                                                }
                                                )
                                                VStack (alignment: .leading){
                                                    Spacer()
                                                    Text("\(card.name)").font(.headline)
                                                    Spacer()
                                                    Text("\(card.set_name)")
                                                    Spacer()
                                                    Text("€ \((card.prices?["eur"] ?? "Price not available") ?? "Price not available")")
                                                    Spacer()
                                                }
                                                Spacer()
                                            }.frame(width: geometry.size.width, height: geometry.size.height*0.15)
                                        }
                                    }
                                }
                                else if ((card.card_faces?.isEmpty) != nil && card.layout != "adventure" && card.layout != "split"){
                                    let faces = card.card_faces
                                    let urlFaceOne = faces?[0].image_uris?["small"]
                                    //                    let urlFaceTwo = faces?[1].image_uris?["small"]
                                    Section{
                                        HStack{
                                            AsyncImage(url: urlFaceOne, content: {image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: (geometry.size.width)*0.15, height: geometry.size.height*0.20)
                                            },
                                                       placeholder: {
                                                ProgressView()
                                            }
                                            )
                                            VStack (alignment: .leading){
                                                Spacer()
                                                Text("\(card.card_faces?[0].name ?? "")").font(.headline)
                                                Spacer()
                                                Text("\(card.set_name)")
                                                Spacer()
                                                Text("€ \((card.prices?["eur"] ?? "Price not available") ?? "Price not available")")
                                                Spacer()
                                            }
                                            Spacer()
                                        }.frame(width: geometry.size.width, height: geometry.size.height*0.15)
                                    }
                                }
                                else if (card.layout == "split"){
                                    Section{
                                        HStack{
                                        AsyncImage(url: card.image_uris?["small"], content: {image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: (geometry.size.width)*0.15, height: geometry.size.height*0.20)
                                        },
                                                   placeholder: {
                                            ProgressView()
                                        }
                                        )
                                        VStack (alignment: .leading){
                                            Spacer()
                                            Text("\(card.card_faces?[0].name ?? "")").font(.headline)
                                            Spacer()
                                            Text("\(card.set_name)")
                                            Spacer()
                                            Text("€ \((card.prices?["eur"] ?? "Price not available") ?? "Price not available")")
                                            Spacer()
                                        
                                        }
                                        Spacer()
                                    }.frame(width: geometry.size.width, height: geometry.size.height*0.15)
                                }
                                }
                            }
                            
                            .task {
                                search = search+textItem.text
                                loadData()
                            }
                        }
                    }
                }
                
                
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemIndigo)))
                        .padding(.bottom, 20)
                }
                
            }
            .navigationTitle("Card Scanner")
            .navigationBarItems(trailing: Button(action: {
                guard !isRecognizing else { return }
                showScanner = true
            }, label: {
                HStack {
                    Image(systemName: "doc.text.viewfinder")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                    
                    Text("Scan")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .frame(height: 36)
                .background(Color(UIColor.systemIndigo))
                .cornerRadius(18)
            }))
        }
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                    case .success(let scannedImages):
                        isRecognizing = true
                        
                        TextRecognition(scannedImages: scannedImages,
                                        recognizedContent: recognizedContent) {
                            // Text recognition is finished, hide the progress indicator.
                            isRecognizing = false
                        }
                        .recognizeText()
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
                
                showScanner = false
                
            } didCancelScanning: {
                // Dismiss the scanner controller and the sheet.
                showScanner = false
            }
        })
    }
    func loadData() {
        print(search)
        search = search.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: search)  {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Response.self, from: data)
                        
                        results = parsedJSON.data
                    } catch {
                        print(error)
                    }
                }
            }.resume()
            
        }
        
                   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
