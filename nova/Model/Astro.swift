import Foundation
import Firebase

@objcMembers class Tema: NSObject, Codable {
    var titulo: String
    var conexoesTemas: [String] // IDs dos temas conectados
    var conexoesReflexoes: [String] // IDs das reflexões conectadas
    var corAura: String
    var tamanho: CGFloat
    var tempoDeVida: CGFloat
    var posicaoX: CGFloat
    var posicaoY: CGFloat
    
    override init() {
        self.titulo = ""
        self.conexoesTemas = []
        self.conexoesReflexoes = []
        self.corAura = ""
        self.tamanho = 0.0
        self.tempoDeVida = 0.0
        self.posicaoX = 0.0
        self.posicaoY = 0.0
    }
    
    init(dictionary: [String: Any]) {
        self.titulo = dictionary["titulo"] as? String ?? ""
        self.conexoesTemas = dictionary["conexoesTemas"] as? [String] ?? []
        self.conexoesReflexoes = dictionary["conexoesReflexoes"] as? [String] ?? []
        self.corAura = dictionary["corAura"] as? String ?? ""
        self.tamanho = dictionary["tamanho"] as? CGFloat ?? 0.0
        self.tempoDeVida = dictionary["tempoDeVida"] as? CGFloat ?? 0.0
        self.posicaoX = dictionary["posicaoX"] as? CGFloat ?? 0.0
        self.posicaoY = dictionary["posicaoY"] as? CGFloat ?? 0.0
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "titulo": titulo,
            "conexoesTemas": conexoesTemas,
            "conexoesReflexoes": conexoesReflexoes,
            "corAura": corAura,
            "tamanho": tamanho,
            "tempoDeVida": tempoDeVida,
            "posicaoX": posicaoX,
            "posicaoY": posicaoY
        ]
    }
}

@objcMembers class Reflexao: NSObject, Codable {
    var estrelaMae: String // ID da estrela mãe
    var texto: String
    var tempoDeVida: CGFloat
    var conexoesReflexoes: [String] // IDs das reflexões conectadas
    var nivel: Int
    var posicaoX: CGFloat
    var posicaoY: CGFloat
    
    override init() {
        self.estrelaMae = ""
        self.texto = ""
        self.tempoDeVida = 0.0
        self.conexoesReflexoes = []
        self.nivel = 0
        self.posicaoX = 0.0
        self.posicaoY = 0.0
    }
    
    init(dictionary: [String: Any]) {
        self.estrelaMae = dictionary["estrelaMae"] as? String ?? ""
        self.texto = dictionary["texto"] as? String ?? ""
        self.tempoDeVida = dictionary["tempoDeVida"] as? CGFloat ?? 0.0
        self.conexoesReflexoes = dictionary["conexoesReflexoes"] as? [String] ?? []
        self.nivel = dictionary["nivel"] as? Int ?? 0
        self.posicaoX = dictionary["posicaoX"] as? CGFloat ?? 0.0
        self.posicaoY = dictionary["posicaoY"] as? CGFloat ?? 0.0
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "estrelaMae": estrelaMae,
            "texto": texto,
            "tempoDeVida": tempoDeVida,
            "conexoesReflexoes": conexoesReflexoes,
            "nivel": nivel,
            "posicaoX": posicaoX,
            "posicaoY": posicaoY
        ]
    }
}

