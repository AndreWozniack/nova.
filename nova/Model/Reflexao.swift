import Foundation
import SpriteKit

class Reflexao: Codable {
    var id = UUID()
    var titulo: String
    var texto: String

    init(titulo: String, texto: String) {
        self.titulo = titulo
        self.texto = texto
    }
}
