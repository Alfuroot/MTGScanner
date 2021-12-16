//
//  FilterSheet.swift
//  MTG-Scanner
//
//  Created by Giuseppe Carannante on 14/12/21.
//

import SwiftUI

struct FilterSheet: View {
    
    @State var isEnabledR: Bool = false
    @State var isEnabledW: Bool = false
    @State var isEnabledB: Bool = false
    @State var isEnabledU: Bool = false
    @State var isEnabledG: Bool = false
    @State var isEnabledCommon: Bool = false
    @State var isEnabledUncommon: Bool = false
    @State var isEnabledRare: Bool = false
    @State var isEnabledMythic: Bool = false
    @State var isEditing: Bool = false
    @State var nameSearch: String = ""
    @State var cmcSearch: String = ""
    @State var colorSearch: String = ""
    @State var raritySearch: String = ""
    @Binding var search: String
    @Binding var showmodal: Bool
    
    var body: some View {
        NavigationView{
            
            VStack (alignment: .leading) {
                HStack{
                    TextField("Card name...", text: $nameSearch)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.isEditing = true
                        }
                    
                    
                    if isEditing {
                        
                        Button(action: {
                            self.isEditing = false
                            self.nameSearch = ""
                            
                        }) {
                            Text("Cancel")
                        }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
                Text("Choose color/s : ")
                    .padding(10)
                    .font(.headline)
                GeometryReader{geometry in
                    HStack(){
                            VStack(){
                            Button(action: {
                                isEnabledW.toggle()
                            }, label: {
                                Text("White")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.27, height: geometry.size.height*0.4, alignment: .center)
                                .background(isEnabledW ? Color(.systemYellow) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            Button(action: {
                                isEnabledU.toggle()
                            }, label: {
                                Text("Blue")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.27, height: geometry.size.height*0.4, alignment: .center)
                                .background(isEnabledU ? Color(.systemBlue) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            }
                            VStack{
                            Button(action: {
                                isEnabledB.toggle()
                            }, label: {
                                Text("Black")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.27, height: geometry.size.height*0.4, alignment: .center)
                                .background(isEnabledB ? Color.black : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            }
                            VStack{
                            Button(action: {
                                isEnabledR.toggle()
                            }, label: {
                                Text("Red")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.27, height: geometry.size.height*0.4, alignment: .center)
                                .background(isEnabledR ? Color(.systemRed) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            Button(action: {
                                isEnabledG.toggle()
                            }, label: {
                                Text("Green")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.27, height: geometry.size.height*0.4, alignment: .center)
                                .background(isEnabledG ? Color(.systemGreen) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            }
                        
                    }
                }
                Text("Choose rarity : ")
                    .padding(10)
                    .font(.headline)
                GeometryReader{geometry in
                    ScrollView(.horizontal){
                        HStack{
                            VStack{
                            Button(action: {
                                isEnabledCommon.toggle()
                                isEnabledMythic = false
                                isEnabledUncommon = false
                                isEnabledRare = false
                            }, label: {
                                Text("Common")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.44, height: geometry.size.height*0.3, alignment: .center)
                                .background(isEnabledCommon ? Color.black : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            Button(action: {
                                isEnabledUncommon.toggle()
                                isEnabledCommon = false
                                isEnabledMythic = false
                                isEnabledRare = false
                            }, label: {
                                Text("Uncommon")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.44, height: geometry.size.height*0.3, alignment: .center)
                                .background(isEnabledUncommon ? Color(.systemTeal) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            }
                            VStack{
                            Button(action: {
                                isEnabledRare.toggle()
                                isEnabledCommon = false
                                isEnabledMythic = false
                                isEnabledUncommon = false
                            }, label: {
                                Text("Rare")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.44, height: geometry.size.height*0.3, alignment: .center)
                                .background(isEnabledRare ? Color(.systemYellow) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            Button(action: {
                                isEnabledMythic.toggle()
                                isEnabledCommon = false
                                isEnabledUncommon = false
                                isEnabledRare = false
                            }, label: {
                                Text("Mythic")
                                    .foregroundColor(Color(.white))
                                    .fontWeight(.bold)
                            })
                                .frame(width: geometry.size.width*0.44, height: geometry.size.height*0.3, alignment: .center)
                                .background(isEnabledMythic ? Color(.systemOrange) : Color(.systemGray))
                                .cornerRadius(10)
                                .padding(10)
                            }
                        }
                    }
                }
                Spacer()
                HStack (spacing: 0){
                    Text("Converted mana cost : ").padding(.leading, 10)
                    Picker("Converted mana cost ", selection: self.$cmcSearch) {
                        Text("Any").tag("Any")
                        ForEach(0 ..< 17) {
                            Text("\($0)").tag(String($0))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 12)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Card list").font(.headline)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack {
                        Button(action: {
                            showmodal.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                        
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Button(action: {
                            if (nameSearch == ""){
                                nameSearch = "*"
                            }
                            if (cmcSearch != "Any" || cmcSearch != ""){
                                cmcSearch = "+cmc%3D%3E0"
                            } else {
                                cmcSearch = "+cmc%3D" + cmcSearch
                            }
                            if(isEnabledU){
                                colorSearch = colorSearch+"u"
                            }
                            if(isEnabledB){
                                colorSearch = colorSearch+"b"
                            }
                            if(isEnabledG){
                                colorSearch = colorSearch+"g"
                            }
                            if(isEnabledW){
                                colorSearch = colorSearch+"w"
                            }
                            if(isEnabledR){
                                colorSearch = colorSearch+"r"
                            }
                            if (colorSearch != ""){
                                colorSearch = "+c%3D" + colorSearch
                            }
                            if (isEnabledCommon == true){
                                raritySearch = "+r%3Dc"
                            }
                            if (isEnabledUncommon == true){
                                raritySearch = "+r%3Du"
                            }
                            if (isEnabledRare == true){
                                raritySearch = "+r%3Dr"
                            }
                            if (isEnabledMythic == true){
                                raritySearch = "+r%3Dm"
                            }
                            
                            search = "https://api.scryfall.com/cards/search?order=eur&q=name%3D"+nameSearch+""+cmcSearch+""+colorSearch+""+raritySearch
                            print(search)
                            showmodal.toggle()
                            
                        }, label: {
                            Text("Done")
                        })
                    }
                }
            }
        }
    }
}

//struct FilterSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterSheet(showmodal: <#T##Binding<Bool>#>)
//    }
//}
