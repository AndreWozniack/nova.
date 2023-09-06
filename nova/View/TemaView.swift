import SwiftUI

struct TemaView: View {
    
    var estrela: Estrela
    
    @State private var titulo: String = ""
    @State private var texto: String = ""

    
    var body: some View {
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    VStack(alignment: .center, spacing: 5) {
                        Spacer()
                        VStack(alignment: .center, spacing: 4) {
                            TextField("Tema", text: $titulo)
                                .autocorrectionDisabled()
                                .cornerRadius(8)
                                .font(
                                    Font.custom("Kodchasan", size: 18)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
//                            HStack(alignment: .center, spacing: 4) {
//                                Text("Planeta gasoso")
//                                    .font(
//                                        Font.custom("SF Pro", size: 9)
//                                            .weight(.bold)
//                                    )
//                                    .foregroundColor(.black)
//                            }
                            .padding(0)
                            Text("Essa estrela tem 1 hora de vida")
                                .font(Font.custom("Inter", size: 9))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }.padding(10)
                        
                            
                        TextField("Reflexão", text: $texto, axis: .vertical)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(width: 260, height: 246, alignment: .topLeading)
                        
                        Button {
                            Manager.shared.estrela = Estrela(reflexao: Reflexao(titulo: self.titulo, texto: self.texto), x: estrela.x, y: estrela.y)
                            Manager.shared.showView = false
                            
                            
                        } label: {
                            Text(.init(systemName: "plus.circle.fill"))
                                .font(.system(size: 32))
                                .foregroundColor(.black)
                        }
                        .padding(.bottom ,24)
                        Spacer()
                    }
                    .padding(.top, 85/2)
                    .frame(width: 300, height: 445, alignment: .top)
                    .background(.white)
                    .cornerRadius(16)
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
//        .background(.black)

        
    }
}



struct TemaView_Previews: PreviewProvider {
    static var previews: some View {
        TemaView(estrela: Estrela(reflexao: Reflexao(titulo: "Amor", texto: "Todos amam"), x: 0, y: 0))
    }
}
