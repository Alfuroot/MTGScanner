//
//  ContentView.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 10/12/21.
//

import SwiftUI

struct Response: Codable {
    var data: [ResultCard]
}

struct ResultCard: Codable {
    var object: String
    var id: UUID
    var mana_cost: String?
    var type_line: String
    var oracle_text: String?
    var keywords: [String]
    var legalities: [String:String]
    var layout: String
    var name: String
    var prices: [String:String?]?
    var prints_search_uri: URL
    var set_name: String
    var image_uris: [String:URL]?
    var card_faces: [Faces]?
}

struct Faces: Codable {
    var image_uris: [String:URL]?
    var name: String
}

struct CardListView: View {
    @State private var results = [ResultCard]()
    @State private var icon_uri = URL(string: "")
    @State var search: String = "https://api.scryfall.com/cards/search?order=eur&q=*"
    @State var showmodal: Bool = false
    
    var body: some View {
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Card list").font(.headline)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        VStack {
                            Button(action: {
                                showmodal.toggle()
                            }, label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            })
                            
                        }
                    }
                }
                
                .task {
                    loadData()
                }
                
                .refreshable {
                    loadData()
                }
            }
        }.sheet(isPresented: $showmodal) {
            FilterSheet(search: $search, showmodal: $showmodal)
                .onDisappear(perform: {
                    loadData()
                })
        }
    }
    func loadData() {
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

struct CardListView_previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
