import SwiftUI

struct CreatePrincipal: View {
    
    var estrela: Estrela
    
    @State private var titulo: String = Manager.shared.palavraDoDia
    @State private var texto: String = ""
    @State var showDica = false

    
    var body: some View {
        ZStack{
            VStack{
                VStack(alignment: .center, spacing: 6) {
                    HStack{
                        Spacer()
                        Button {
                            showDica.toggle()
                        } label: {
                            if showDica {
                                Image(systemName: "lightbulb.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color("dica"))
                            } else {
                                Image(systemName: "lightbulb.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(uiColor: .systemGray))
                            }
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 4) {
                        TextField("Tema", text: $titulo)
                            .autocorrectionDisabled()
                            .cornerRadius(8)
                            .font(Font.custom("Kodchasan-Bold", size: 20))
                            .multilineTextAlignment(.center)
                        
                        Text(estrela.tipo!.rawValue)
                            .font(
                                Font.custom("SF Pro", size: 12)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                        Text("\(estrela.getDuracao()) de vida")
                            .font(Font.custom("Kodchasan-Regular", size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }.padding(10)
                    if showDica {
                        Text("Como essa palavra se relacionou com o seu dia hoje?")
                            .frame(width: 195, height: 28)
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                            .foregroundColor(Color("dica"))
                            .padding(12)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("dica"), lineWidth: 2))
                    }
                    TextField("Escreva sua reflexão aqui", text: $texto, axis: .vertical)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(width: 260, alignment: .topLeading)
                    Spacer()
                    HStack(spacing: 12){
                        Button {
                            Manager.shared.showCreatePrincipal = false
                        } label: {
                            HStack{
                                Text("Cancelar")
                                    .font(.custom("Kodchasan-Bold", size: 13))
                                    .foregroundColor(.white)
                                    .font(.caption2)
                                    .bold()
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(.black)
                            .cornerRadius(12)
                        }
                        Button {
                            Manager.shared.estrela = Estrela(reflexao: Reflexao(titulo: self.titulo, texto: self.texto), x: estrela.x, y: estrela.y, tipo: estrela.tipo)
                            
                            Manager.shared.showCreatePrincipal = false
                        } label: {
                            HStack{
                                Text("Adicionar")
                                    .font(.custom("Kodchasan-Bold", size: 13))
                                    .foregroundColor(.white)
                                    .font(.caption2)
                                    .bold()
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(.black)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                .frame(width: 300, height: 445, alignment: .top)
                .background(.white)
                .cornerRadius(16)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(.black, lineWidth: 1)
//                )
                
            }
        }
    }
}



struct TemaView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePrincipal(estrela: Estrela(reflexao: Reflexao(titulo: "Amor", texto: "Todos amam"), x: 0, y: 0, tipo: .anaBranca))
    }
}
