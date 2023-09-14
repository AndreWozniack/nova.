import SwiftUI

struct PrincipalDescriptionView: View {
    
    var estrela : Estrela
    @State private var formattedTime: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var textoEditado = ""
    @State var tituloEditado = ""
    @State var editing = false
    @State var textoOriginal = ""
    @State var tituloOriginal = ""
    
    var body: some View {
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    VStack(alignment: .center) {
                        VStack(spacing: 6){
                            HStack{
                                Spacer()
                                Button {
                                    editing.toggle()
                                } label: {
                                    if editing {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(Color("dica"))
                                    } else {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(Color(uiColor: .systemGray))
                                    }
                                }
                            }
                            .padding(.horizontal)
                            if editing {
                                TextField("Título", text: $tituloEditado)
                                    .font(.custom("Kodchasan-Bold", size: 20))
                                    .padding(.top, -20)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text(estrela.reflexao.titulo)
                                    .font(.custom("Kodchasan-Bold", size: 20))
                                    .fontWeight(.bold)
                                    .padding(.top, -20)
                            }
                            //tema da estrela
                            VStack(spacing: 4){
                                HStack(alignment: .center, spacing: 4){
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                    //ícone do astro
                                        .foregroundColor(Color(uiColor: .systemGray))
                                    Text(estrela.tipo!.rawValue)
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(uiColor: .systemGray))
                                    //nome do astro
                                }
                                HStack{
                                    Text("Tempo restante:")
                                        .font(.caption2)
                                        .foregroundColor(Color(uiColor: .systemGray))
                                        .onAppear() {
                                            formattedTime = "Calculando"
                                        }
                                        .onReceive(timer) { _ in
                                            formattedTime = estrela.tempoRestanteString
                                        }
                                    Text("\(formattedTime)") // Exiba o tempo formatado
                                        .font(.caption2)
                                        .foregroundColor(Color(uiColor: .systemGray))
                                        .onReceive(timer) { _ in
                                            formattedTime = estrela.tempoRestanteString
                                        }
                                }
                            }
                        }
                            .padding(.top, 85/2)
                        ScrollView{
                            TextField(estrela.reflexao.texto, text: $textoEditado, axis: .vertical)
                                .font(.system(size: 16))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 20)
                                .frame(width: 260, alignment: .topLeading)
                                .foregroundColor(.black)
                                .disabled(!editing)
                        }
                        .onAppear{
                            textoEditado = estrela.reflexao.texto
                            textoOriginal = textoEditado
                            
                            tituloEditado = estrela.reflexao.titulo
                            tituloOriginal = tituloEditado
                        }
                        if !editing {
                            HStack(spacing: 12){
                                Button {
                                    Manager.shared.showSubCreate = true
                                    Manager.shared.showCreatePrincipal = false
                                } label: {
                                    HStack{
                                        Text("Adicionar outro astro.")
                                            .font(.custom("Kodchasan-Bold", size: 13))
                                            .foregroundColor(.white)
                                            .font(.caption2)
                                            .bold()
                                        Image(systemName: "moon.stars.fill")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(.black)
                                    .cornerRadius(12)
                                }
                            }
                            .padding()
                        } else {
                            HStack(spacing: 12){
                                Button {
                                    textoEditado = textoOriginal
                                    editing.toggle()
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
                                    estrela.reflexao.texto = textoEditado
                                    estrela.reflexao.titulo = tituloEditado
                                    EstrelaManager.shared.updateEstrela(estrela)
                                    editing.toggle()
                                } label: {
                                    HStack{
                                        Text("Salvar")
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
                            }.padding()
                        }
                    }
                    .frame(width: 300, height: 445, alignment: .top)
                    .background(.white)
                    .cornerRadius(16)
                }
                
                VStack{
                    ZStack{
                        Circle()
                            .strokeBorder(Color.white,lineWidth: 2)
                            .background(Circle().foregroundColor(Color.black))
                            .frame(width: 85, height: 85)
                        Image(estrela.getIcon())
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                }
                
            }
            .frame(width: 300, height: 487.5)
        }

        
        
    }
}


struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PrincipalDescriptionView(estrela: geraEstrela())
    }
}

func geraEstrela() -> Estrela {
    let estrela = Estrela(reflexao: Reflexao(titulo: "Amizade", texto: "A amizade é uma das joias mais preciosas que podemos encontrar ao longo da vida. Ela é como um jardim que requer cuidado constante, regado com amor, confiança e apoio mútuo. Assim como as flores desabrocham e crescem com o tempo, as verdadeiras amizades também se fortalecem com as experiências compartilhadas e os desafios enfrentados juntos."), x: 0, y: 0, tipo: .anaAmarela)
    return estrela
}
