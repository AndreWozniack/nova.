//
//  CardsView.swift
//  nova
//
//  Created by André Wozniack on 05/09/23.
//

import SwiftUI

struct CardsView: View {

    
    var body: some View {
        ZStack{
            ScrollView(.horizontal) {
                TabView{
                    ForEach(EstrelaManager.shared.todasEstrelas, id: \.id) { estrela in
                        DescriptionView(estrela: estrela)
                            .padding(.horizontal, 25)
                    }
                }
                .tabViewStyle(.page)
                .padding()
                
            }
        }
    }
}



struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
