import SwiftUI

struct DescriptionView: View {
    
    var estrela : Estrela
    
    var body: some View {
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    VStack(alignment: .center, spacing: 5) {
                        Spacer()
                        VStack(alignment: .center, spacing: 4) {
                            Text(estrela.reflexao.titulo)
                                .cornerRadius(8)
                                .font(
                                    Font.custom("Kodchasan", size: 18)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            HStack(alignment: .center, spacing: 4) {
                                Text("Planeta gasoso")
                                    .font(
                                        Font.custom("SF Pro", size: 9)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                            }
                            .padding(0)
                            Text("20 dias de vida restante")
                                .font(Font.custom("Inter", size: 9))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 124, alignment: .top)
                        }.padding(5)
                            .padding(.top, 85/2)
                        ScrollView{
                            Text(estrela.reflexao.texto)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(width: 260, height: .infinity, alignment: .topLeading)
                                .foregroundColor(.black)
                        }
                        Button {
                            Manager.shared.showNewView = false
                            
//                            let novaEstrela = criarNovaEstrelaBaseadaEm(estrela)
//                            conectarEstrelas(estrela1: estrela, estrela2: novaEstrela)
//                            estrela.conexoes.append(novaEstrela.id)
//                            EstrelaManager.shared.addConexao(from: estrela, to: novaEstrela)
//                            print(EstrelaManager.shared.todasEstrelas)
                            
                        } label: {
                            Text("Adicionar nova estrela")
                                .padding(10)
                                .background(.black)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                
                        }
                        .padding(.bottom ,24)
                        .padding(.top, 10)
                    }
                    
                    .frame(width: 300, height: 445, alignment: .top)
                    .background(.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 1)
                    )
                }
                
                VStack{
                    Circle()
                        .strokeBorder(Color.white,lineWidth: 2)
                        .background(Circle().foregroundColor(Color.black))
                        .frame(width: 85, height: 85)
                    Spacer()
                }
                
            }
            .frame(width: 300, height: 487.5)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }
}


struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(estrela: Estrela(reflexao: Reflexao(titulo: "Tema", texto: "A amizade é uma das joias mais preciosas que podemos encontrar ao longo da vida. Ela é como um jardim que requer cuidado constante, regado com amor, confiança e apoio mútuo. Assim como as flores desabrocham e crescem com o tempo, as verdadeiras amizades também se fortalecem com as experiências compartilhadas e os desafios enfrentados juntos."), x: 0, y: 0))
    }
}
