import Foundation

class Reflexao: Codable {
    var titulo: String
    var texto: String

    init(titulo: String, texto: String) {
        self.titulo = titulo
        self.texto = texto
    }
}
