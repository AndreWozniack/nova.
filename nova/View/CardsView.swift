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
                LazyHGrid(rows: [GridItem(.fixed(200))], spacing: 20) {
                    ForEach(EstrelaManager.shared.todasEstrelas, id: \.id) { estrela in
                        DescriptionView(estrela: estrela)
                            .padding(.horizontal, 25)
                    }
                }
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
