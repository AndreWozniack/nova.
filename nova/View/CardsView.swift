import SwiftUI

struct CardsView: View {
    
    @State private var currentTab = UUID()

    var body: some View {
        let estrelasList = flattenConnectionsDictionary(Manager.shared.estrelaConnections)
        
        if estrelasList.count == 0 {
            if Manager.shared.estrelaTocada.nivel == 0 {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                Manager.shared.showSubDescription = false
                                Manager.shared.showPrincipalDescription = false
                            }
                        }
                    PrincipalDescriptionView(estrela: Manager.shared.estrelaTocada)
                        .padding()
                }
            } else {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                Manager.shared.showSubDescription = false
                                Manager.shared.showPrincipalDescription = false
                            }
                        }
                    SubDescriptionView(estrela: Manager.shared.estrelaTocada)
                        .padding()
                }
            }
        } else {
            TabView(selection: $currentTab) {
                ForEach(flattenConnectionsDictionary(Manager.shared.estrelaConnections), id: \.id) { estrela in
                    ZStack{
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    Manager.shared.showSubDescription = false
                                    Manager.shared.showPrincipalDescription = false
                                }
                            }
                        if estrela.nivel == 0 {
                            PrincipalDescriptionView(estrela: estrela)
                                .padding()
                                .tag(estrela.id)
                            
                        } else {
                            SubDescriptionView(estrela: estrela)
                                .padding()
                                .tag(estrela.id)
                        }
                    }
                }
            }.tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onAppear(){
                    currentTab = Manager.shared.estrelaTocada.id
                }
        }
    
    }
    
    func flattenConnectionsDictionary(_ connections: [Estrela: [Estrela]]) -> [Estrela] {
        var estrelasList: [Estrela] = []

        for (estrela, subEstrelas) in connections {
            estrelasList.append(estrela)
            estrelasList.append(contentsOf: subEstrelas)
        }

        // Removendo duplicatas
        let uniqueEstrelasList = Array(Set(estrelasList))

        // Ordenando as estrelas pelo nível em ordem decrescente para que a estrela de nível mais alto seja a primeira
        let sortedEstrelasList = uniqueEstrelasList.sorted { $0.nivel > $1.nivel }

        return sortedEstrelasList
    }


}



struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
