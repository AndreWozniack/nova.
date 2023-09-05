import Foundation

class Manager : ObservableObject {
    static let shared = Manager()
    @Published var estrela = Estrela()
    @Published var showView = false
    @Published var showNewView = false
    @Published var estrelaTocada = Estrela()

    private init() {}
}
