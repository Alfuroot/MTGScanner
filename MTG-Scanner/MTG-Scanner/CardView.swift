//
//  CardView.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 12/12/21.
//

import SwiftUI

struct CardView: View {
    
    @State var expanded = false
    @State var card: ResultCard
    @State private var cardPrints: [ResultCard] = []
    @State var currView: String = "Prices"
    
    var body: some View {
        GeometryReader{geometry in
            VStack (spacing: 0){
                AsyncImage(url: card.image_uris?["art_crop"], content: {image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height*0.46)
                },
                           placeholder: {
                    ProgressView()
                }
                )
                
                
                Text(card.name)
                    .font(.system(size: 24)).bold()
                    .padding(10)
                Picker(selection: self.$currView, label: Text("Picker")){
                    Text("Prices").tag("Prices")
                    Text("Details").tag("Details")
                }.pickerStyle(SegmentedPickerStyle())
                if (currView == "Prices"){
                    List(cardPrints, id: \.id) { cardPrint in
                            HStack{
                                AsyncImage(url: cardPrint.image_uris?["small"], content: {image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (geometry.size.width)*0.25, height: geometry.size.height*0.25)
                                },
                                           placeholder: {
                                    ProgressView()
                                }
                                )
                                VStack (alignment: .leading){
                                    Spacer()
                                    Text("\(cardPrint.name)").font(.headline)
                                    Spacer()
                                    Text("\(cardPrint.set_name)")
                                    Spacer()
                                    Text("€ \((cardPrint.prices?["eur"] ?? "Price not available") ?? "Price not available")")
                                    Spacer()
                                }
                                Spacer()
                            }
                        
                    }
                    
                    .task {
                        loadPrints()
                    }
                    .refreshable{
                        loadPrints()
                    }
                }
                else {
                    VStack(alignment: .leading){
                        List{
                            Section(header: Text("Card type:")){
                                Text(card.type_line)
                            }
                            Section(header: Text("Mana cost:")){
                                if (card.mana_cost != ""){
                                    Text(card.mana_cost ?? "0")
                                }
                                else {
                                    Text("None")
                                }
                            }
                            if (!card.keywords.isEmpty){
                                Section(header: Text("Keywords:")){
                                    ForEach (card.keywords.indices){
                                        Text("\(card.keywords[$0])").listRowSeparator(.hidden)
                                    }
                                }
                            }
                            if ((card.oracle_text) != nil){
                            Section(header: Text("Oracle text:")){
                                ZStack{
                                    Text(card.oracle_text ?? "")
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                            }
                            }
                            Section(header:
                                        HStack{
                                Text("Legalities:")
                                Spacer()
                                Button(action: {
                                    expanded.toggle()
                                }, label: {
                                    if (expanded){
                                        Image(systemName: "chevron.right")
                                    }
                                    else {
                                        Image(systemName: "chevron.down")
                                    }
                                })
                            }){
                                VStack(alignment: .leading){
                                    let keys = card.legalities.map{$0.key}
                                    let values = card.legalities.map{$0.value}
                                    
                                    ForEach(Array(zip(keys, values)).sorted(by: >).prefix(upTo: expanded ? keys.count : 1), id: \.0) {index in
                                        HStack{
                                            Text((index.0).uppercased())
                                            Spacer()
                                            Text(index.1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    func loadPrints() {
        if let url = URL(string: "\(card.prints_search_uri)")  {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Response.self, from: data)
                        
                        cardPrints = parsedJSON.data
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
