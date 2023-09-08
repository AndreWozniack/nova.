import Foundation

class Manager : ObservableObject {
    static let shared = Manager()
    @Published var estrela = Estrela()
    @Published var estrelaTocada = Estrela()
    @Published var subEstrela = Estrela()
    @Published var showView = false
    @Published var showNewView = false
    @Published var showSubView = false
    @Published var showSubDescriptionView = false


    private init() {}
}
