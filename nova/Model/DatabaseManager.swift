import Foundation
import Firebase

class DatabaseManager : ObservableObject {
    
    private let db = Database.database().reference()
    
    // Create
    func createTema(tema: Tema) {
        db.child("temas").child(tema.titulo).setValue(tema.toDictionary())
    }
    
    func createReflexao(reflexao: Reflexao) {
        db.child("reflexoes").childByAutoId().setValue(reflexao.toDictionary())
    }
    
    func readTema(titulo: String, completion: @escaping (Tema?) -> Void) {
        db.child("temas").child(titulo).observeSingleEvent(of: .value) { (snapshot, error) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let tema = Tema(dictionary: value)
            
            let estrela = Estrela(texto: tema.titulo, x: tema.posicaoX, y: tema.posicaoY)
            estrela.tema = tema
            // ... adicionar estrela à cena ...
            
            completion(tema)
        }

    }

    func readReflexao(id: String, completion: @escaping (Reflexao?) -> Void) {
        db.child("reflexoes").child(id).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let reflexao = Reflexao(dictionary: value)
            
            completion(reflexao)
        }
    }
    
    // Update
    func updateTema(titulo: String, newTema: Tema) {
        db.child("temas").child(titulo).setValue(newTema.toDictionary())
    }
    
    func updateReflexao(id: String, newReflexao: Reflexao) {
        db.child("reflexoes").child(id).setValue(newReflexao.toDictionary())
    }
    
    // Delete
    func deleteTema(titulo: String) {
        db.child("temas").child(titulo).removeValue()
    }
    
    func deleteReflexao(id: String) {
        db.child("reflexoes").child(id).removeValue()
    }
}
