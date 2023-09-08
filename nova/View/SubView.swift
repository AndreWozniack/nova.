//
//  SubView.swift
//  nova
//
//  Created by André Wozniack on 05/09/23.
//

import SwiftUI

struct SubView: View {
    
    @State private var titulo: String = ""
    @State private var texto: String = ""

    
    var body: some View {
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    VStack(alignment: .center, spacing: 5) {
                        VStack(alignment: .center, spacing: 4) {
                            Text("\(Manager.shared.estrelaTocada.reflexao.titulo)")
                                .bold()
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                            TextField("Tema", text: $titulo)
                                .autocorrectionDisabled()
                                .cornerRadius(8)
                                .font(
                                    Font.custom("Kodchasan", size: 18)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                            
                            HStack(alignment: .center, spacing: 4) {
                                Text("Gigante Amarela")
                                    .font(
                                        Font.custom("SF Pro", size: 9)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                            }
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
                            .frame(width: 260, height: 220, alignment: .topLeading)
                            
                        
                        HStack{
                            Button {
                                Manager.shared.showSubView = false
                            } label: {
                                HStack{
                                    Text("Cancelar")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                    Text(.init(systemName: "x.circle.fill"))
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                                .background(Color.black)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            Button {
                                let ponto = novoPontoAoRedorDe(x: Manager.shared.estrelaTocada.x, y: Manager.shared.estrelaTocada.y, nivel: Manager.shared.estrelaTocada.nivel)
                                let novaEstrela = Estrela(reflexao: Reflexao(titulo: self.titulo, texto: self.texto), x: ponto.x, y: ponto.y)
                                
                                if let estrelaOrigem = EstrelaManager.shared.getEstrela(byID: Manager.shared.estrelaTocada.id){
                                    novaEstrela.estrelaOrigem = estrelaOrigem.id
                                    novaEstrela.nivel = estrelaOrigem.nivel + 1
                                    Manager.shared.subEstrela = novaEstrela
                                    EstrelaManager.shared.addEstrela(novaEstrela)
                                    EstrelaManager.shared.updateEstrela(estrelaOrigem)
                                    print(estrelaOrigem)
                                }
                                
                              
                                Manager.shared.showSubView = false
                                
                            } label: {
                                HStack{
                                    Text("Adicionar")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                    Text(.init(systemName: "checkmark.circle.fill"))
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                                .background(Color.black)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                        }
                        .padding(.bottom ,24)
                    }
                    .padding(.top, 85/2)
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
//        .background(.black)

        
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
    
    func novoPontoAoRedorDe(x: CGFloat, y: CGFloat, nivel: Int) -> CGPoint {
        let distanciaMaxima = distanciaMaximaParaNivel(nivel)
        
        while true {
            // Gere um ângulo aleatório entre 0 e 2 * π
            let angulo = CGFloat.random(in: 0...(2 * .pi))
            
            // Calcule um deslocamento aleatório dentro da distância máxima permitida
            let distanciaAleatoria = CGFloat.random(in: 0...(distanciaMaxima / 2))
            
            // Calcule as coordenadas do novo ponto com base no ângulo e distância
            let novoX = x + cos(angulo) * distanciaAleatoria
            let novoY = y + sin(angulo) * distanciaAleatoria
            
            // Verifique se a nova posição é válida usando a função posicaoEhValida
            if posicaoEhValida(x: novoX, y: novoY) {
                return CGPoint(x: novoX, y: novoY)
            }
            // Se a posição não for válida, continue gerando novos pontos
        }
    }


}


struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView()
    }
}
