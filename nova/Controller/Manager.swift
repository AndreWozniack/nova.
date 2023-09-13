import Foundation

class Manager : ObservableObject {
    static let shared = Manager()
    @Published var estrela = Estrela()
    @Published var estrelaTocada = Estrela()
    @Published var subEstrela = Estrela()
    @Published var showCreatePrincipal = false
    @Published var showPrincipalDescription = false
    @Published var showSubCreate = false
    @Published var showSubDescription = false
    @Published var palavraDoDia: String = EstrelaManager.shared.palavraDoDia!
    @Published var estrelaConnections: [Estrela: [Estrela]] = [:]
    
    private init() {}
    
    func updateEstrelaConnections(from subRede: [Estrela: [Estrela]]) {
        self.estrelaConnections = subRede
    }
}
