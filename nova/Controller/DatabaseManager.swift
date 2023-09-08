import Foundation
import Combine

class EstrelaManager: ObservableObject {
    
    static let shared = EstrelaManager()

    @Published var todasEstrelas: [Estrela] = []
    @Published var estrelasExpiradas: [Estrela] = []

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
        if let encodedEstrelas = try? encoder.encode(todasEstrelas) {
            UserDefaults.standard.set(encodedEstrelas, forKey: "todasEstrelas")
            print("Salvo.")
        } else {
            print("Erro ao codificar e salvar dados no UserDefaults.")
        }
    }

    func loadFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedEstrelas = UserDefaults.standard.object(forKey: "todasEstrelas") as? Data{
            do {
                let loadedEstrelas = try decoder.decode([Estrela].self, from: savedEstrelas)
                todasEstrelas = loadedEstrelas
                print("Dados carregados do UserDefaults.")
            } catch {
                print("Erro ao decodificar dados do UserDefaults: \(error)")
            }

        } else {
            print("Nenhum dado encontrado no UserDefaults.")
        }
        filterExpiredEstrelas()
    }


    func addEstrela(_ estrela: Estrela) {
        if !todasEstrelas.contains(where: { $0.id == estrela.id }) {
            todasEstrelas.append(estrela)
        }
        saveToUserDefaults()
    }

    func updateEstrela(_ updatedEstrela: Estrela) {
        guard let index = todasEstrelas.firstIndex(where: { $0.id == updatedEstrela.id }) else {
            return
        }
        todasEstrelas[index] = updatedEstrela
    }
    
    func getEstrela(byID id: UUID) -> Estrela? {
        return todasEstrelas.first { $0.id == id }
    }    

    func removeEstrela(_ estrela: Estrela) {
        todasEstrelas.removeAll { $0.id == estrela.id }
    }

    func filterExpiredEstrelas() {
        let currentDate = Date()
        estrelasExpiradas = todasEstrelas.filter { estrela in
            let endDate = estrela.dataInicio.addingTimeInterval(estrela.duracao)
            return currentDate > endDate
        }

        todasEstrelas = todasEstrelas.filter { estrela in
            let endDate = estrela.dataInicio.addingTimeInterval(estrela.duracao)
            return currentDate <= endDate
        }
    }
    func getEstrelaDeOrigemParaEstrela(_ estrela: Estrela) -> Estrela? {
        guard let estrelaOrigemID = estrela.estrelaOrigem else {
            return nil
        }
        return todasEstrelas.first { $0.id == estrelaOrigemID }
    }

    
    func clearSky(){
        todasEstrelas.removeAll()
        print(todasEstrelas)
    }
}
