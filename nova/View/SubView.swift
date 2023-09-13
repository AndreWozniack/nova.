import SwiftUI

struct SubView: View {
    
    @State var titulo: String = ""
    @State var texto: String = ""
    @State var novaEstrela = Estrela()
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
                                    .foregroundColor(Color(uiColor: .blue))
                            } else {
                                Image(systemName: "lightbulb.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(uiColor: .systemGray))
                            }
                        }
                    }
                    VStack(alignment: .center, spacing: 10) {
                        Text("\(Manager.shared.estrelaTocada.reflexao.titulo)")
                            .bold()
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        TextField("Tema", text: $titulo)
                            .autocorrectionDisabled()
                            .cornerRadius(8)
                            .font(Font.custom("Kodchasan-Bold", size: 20))
                            .multilineTextAlignment(.center)
                        
                        Text(novaEstrela.tipo!.rawValue)
                            .font(Font.custom("SF Pro", size: 12)
                                    .weight(.bold))
                            .foregroundColor(.black)
                        Text("\(novaEstrela.getDuracao()) de vida")
                            .font(Font.custom("Inter", size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }.padding(10)
                    if showDica {
                        Text("Como essa palavra se relacionou com o seu dia hoje?")
                            .frame(width: 195, height: 28)
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                            .foregroundColor(Color(uiColor: .green))
                            .padding(12)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(uiColor: .green), lineWidth: 2))
                    }
                    
                    TextField("Reflexão", text: $texto, axis: .vertical)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(width: 260, alignment: .topLeading)
                    
                    Spacer()
                    HStack{
                        Button {
                            Manager.shared.showSubView = false
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
                            let ponto = novoPontoAoRedorDe(Manager.shared.estrelaTocada)
                            novaEstrela = Estrela(reflexao: Reflexao(titulo: self.titulo, texto: self.texto), x: ponto.x, y: ponto.y, tipo: novaEstrela.tipo!)
                            
                            if let estrelaOrigem = EstrelaManager.shared.getEstrela(byID: Manager.shared.estrelaTocada.id){
                                novaEstrela.estrelaOrigem = estrelaOrigem.id
                                novaEstrela.nivel = estrelaOrigem.nivel + 1
                                Manager.shared.subEstrela = novaEstrela
                                EstrelaManager.shared.addEstrela(novaEstrela)
                                EstrelaManager.shared.updateEstrela(estrelaOrigem)
                            }
                            Manager.shared.showSubView = false
                            
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
                    .padding(.bottom ,24)
                }
                .padding()
                .frame(width: 300, height: 500, alignment: .top)
                .background(.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 1)
                )
            }
            .onAppear {
                let _ = novaEstrela.tipoAleatorio()
            }
        }
        
        
    }
    func posicaoEhValida(x: CGFloat, y: CGFloat) -> Bool {
        let novaPosicao = CGPoint(x: x, y: y)
        for estrela in EstrelaManager.shared.todasEstrelas {
            if estrela.position.distance(to: novaPosicao) < 30 {
                return false
            }
        }
        return true
    }
    
    func distanciaMaximaParaNivel(_ nivel: Int) -> CGFloat {
        switch nivel {
        case 0: return 700
        case 1: return 400
        case 2: return 200
        default: return 70
        }
    }
    
    func novoPontoAoRedorDe(_ estrela: Estrela) -> CGPoint {
        let distanciaMaxima = distanciaMaximaParaNivel(estrela.nivel)
        let distanciaMinima = distanciaMaximaParaNivel(estrela.nivel - 1)
        
        while true {
            let angulo = CGFloat.random(in: 0...(2 * .pi))
            let distanciaAleatoria = CGFloat.random(in: 0...(distanciaMaxima / 2)) + estrela.addTamanho()
            
            let novoX = estrela.x + cos(angulo) * distanciaAleatoria
            let novoY = estrela.y + sin(angulo) * distanciaAleatoria
            if posicaoEhValida(x: novoX, y: novoY) {
                return CGPoint(x: novoX, y: novoY)
            }
        }
    }
    
    func tamanhoNivel(_ nivel:Int) -> CGFloat{
        switch nivel {
        case 1:
            return CGFloat(20)
        case 2:
            return CGFloat(10)
        case 3:
            return CGFloat(5)
        default:
            return CGFloat(40)
        }
    }
}

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView()
    }
}
