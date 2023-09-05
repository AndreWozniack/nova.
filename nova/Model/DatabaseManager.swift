import Foundation
import Combine

class EstrelaManager: ObservableObject {
    static let shared = EstrelaManager()

    @Published var todasEstrelas: [Estrela] = []
    @Published var conexoes: [UUID: [UUID]] = [:]  // Mapeia uma estrela para suas conexões

    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadFromUserDefaults()
        setupBindings()
    }

    private func setupBindings() {
        $todasEstrelas
            .sink { [weak self] updatedEstrelas in
                self?.saveToUserDefaults()
            }
            .store(in: &cancellables)
    }

    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encodedEstrelas = try? encoder.encode(todasEstrelas),
           let encodedConexoes = try? encoder.encode(conexoes) {
            UserDefaults.standard.set(encodedEstrelas, forKey: "todasEstrelas")
            UserDefaults.standard.set(encodedConexoes, forKey: "conexoes")
        }
    }

    func loadFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedEstrelas = UserDefaults.standard.object(forKey: "todasEstrelas") as? Data,
           let savedConexoes = UserDefaults.standard.object(forKey: "conexoes") as? Data {
            if let loadedEstrelas = try? decoder.decode([Estrela].self, from: savedEstrelas),
               let loadedConexoes = try? decoder.decode([UUID: [UUID]].self, from: savedConexoes) {
                todasEstrelas = loadedEstrelas
                conexoes = loadedConexoes
            }
        }
        filterExpiredEstrelas()
    }

    func addEstrela(_ estrela: Estrela) {
        if !todasEstrelas.contains(where: { $0.id == estrela.id }) {
            todasEstrelas.append(estrela)
        }
    }

    func addConexao(from estrelaOrigem: Estrela, to estrelaDestino: Estrela) {
        if conexoes[estrelaOrigem.id] != nil {
            conexoes[estrelaOrigem.id]?.append(estrelaDestino.id)
        } else {
            conexoes[estrelaOrigem.id] = [estrelaDestino.id]
        }
    }

    func removeEstrela(_ estrela: Estrela) {
        todasEstrelas.removeAll { $0.id == estrela.id }
        conexoes[estrela.id] = nil
        saveToUserDefaults()
    }

    private func filterExpiredEstrelas() {
        let currentDate = Date()
        todasEstrelas = todasEstrelas.filter { estrela in
            let endDate = estrela.dataInicio.addingTimeInterval(estrela.duracao)
            return currentDate <= endDate
        }
    }
}
