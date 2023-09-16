import Foundation
import Combine

class EstrelaManager: ObservableObject {
    
    static let shared = EstrelaManager()

    @Published var todasEstrelas: [Estrela] = []
    @Published var estrelasExpiradas: [Estrela] = []
    @Published var palavraDoDia: String? {
        didSet {
            UserDefaults.standard.set(palavraDoDia, forKey: "PalavraDoDia")
        }
    }
    @Published var palavrasUsadas: [String] = [] {
        didSet {
            UserDefaults.standard.set(palavrasUsadas, forKey: "PalavrasUsadas")
        }
    }
    @Published var ultimaVisita: Date? {
        didSet {
            UserDefaults.standard.set(ultimaVisita, forKey: "UltimaVisita")
        }
    }
    
    private var ultimaDataGerada: Date? {
        get {
            return UserDefaults.standard.object(forKey: "UltimaDataGerada") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UltimaDataGerada")
        }
    }
    var palavras = [
        "Abraço",
        "Aceitação",
        "Aconchego",
        "Acordar",
        "Adaptabilidade",
        "Alegria",
        "Algoritmo",
        "Amizade",
        "Amor",
        "Amor-próprio",
        "Animais",
        "Aprendizado",
        "Ar",
        "Arco-íris",
        "Argumento",
        "Aroma",
        "Arte",
        "Assaltar",
        "Assento",
        "Autenticidade",
        "Autoaceitação",
        "Autoconfiança",
        "Autoconhecimento",
        "Aventura",
        "Avião",
        "Ação",
        "Açúcar",
        "Bactéria",
        "Baleia",
        "Beijo",
        "Beleza",
        "Biodiversidade",
        "Bola",
        "Brincadeira",
        "Brisa",
        "Cachoeira",
        "Cachorro",
        "Cadeia",
        "Café",
        "Calor",
        "Cama",
        "Caminho",
        "Campo",
        "Caneta",
        "Canto",
        "Canção",
        "Carinho",
        "Carro",
        "Carícia",
        "Cavalo",
        "Celular",
        "Chocolate",
        "Chuva",
        "Chá",
        "Classificação",
        "Comida",
        "Compaixão",
        "Companhia",
        "Compreensão",
        "Computador",
        "Comunicação",
        "Conexão",
        "Congelar",
        "Conhecimento",
        "Coragem",
        "Coração",
        "Cores",
        "Cozinha",
        "Crescimento",
        "Criança",
        "Curiosidade",
        "Célula",
        "Céu",
        "Dança",
        "Desafio",
        "Desapego",
        "Descanso",
        "Descoberta",
        "Desejo",
        "Deserto",
        "Dia",
        "Dinheiro",
        "Ecologia",
        "Ecossistema",
        "Elefante",
        "Empatia",
        "Empoderamento",
        "Encanto",
        "Enigma",
        "Epistemologia",
        "Equidade",
        "Equilíbrio",
        "Escada",
        "Escola",
        "Escrita",
        "Escrivaninha",
        "Escultura",
        "Espaço",
        "Espelho",
        "Esperança",
        "Estrela",
        "Euforia",
        "Evolução",
        "Existência",
        "Exploração",
        "Fascinação",
        "Fedor",
        "Felicidade",
        "Felino",
        "Festa",
        "Flores",
        "Floresta",
        "Fogo",
        "Fotografia",
        "Fragrância",
        "Fumaça",
        "Fungar",
        "Futebol",
        "Férias",
        "Gato",
        "Geada",
        "Gelo",
        "Generosidade",
        "Genética",
        "Girafa",
        "Glacial",
        "Golfinho",
        "Gratidão",
        "Guitarra",
        "Gélido",
        "Hardware",
        "Harmonia",
        "Hereditariedade",
        "História",
        "Honestidade",
        "Humildade",
        "Humor",
        "Imaginação",
        "Individualidade",
        "Infantil",
        "Infância",
        "Inovação",
        "Inspirar",
        "Inspiração",
        "Integridade",
        "Interdependência",
        "Internet",
        "Introspecção",
        "Intuição",
        "Inverno",
        "Janela",
        "Jardim",
        "Laranja",
        "Lavanda",
        "Leão",
        "Liberdade",
        "Livro",
        "Lobo",
        "Lua",
        "Luminária",
        "Lágrima",
        "Lógica",
        "Madeira",
        "Mamífero",
        "Mar",
        "Maravilha",
        "Maré",
        "Maturidade",
        "Mau",
        "Maçã",
        "Meio Ambiente",
        "Melodia",
        "Memória",
        "Mesa",
        "Metafísica",
        "Mindfulness",
        "Miragem",
        "Mistério",
        "Molhado",
        "Montanha",
        "Moral",
        "Morno",
        "Mouse",
        "Mutação",
        "Mágica",
        "Música",
        "Narina",
        "Nariz",
        "Natureza",
        "Neve",
        "Noite",
        "Oceano",
        "Odor",
        "Olfato",
        "Olhos",
        "Onda",
        "Ouro",
        "Ouvir",
        "Paciência",
        "Paixão",
        "Palavra",
        "Peixe",
        "Penas",
        "Pensamento",
        "Perdão",
        "Perfume",
        "Perseverança",
        "Persistência",
        "Pinguim",
        "Planta",
        "Poema",
        "Poesia",
        "Poltrona",
        "Polícia",
        "Porta",
        "Praia",
        "Processador",
        "Profundidade",
        "Programa",
        "Propósito",
        "Pássaro",
        "Pôr do sol",
        "Quente",
        "Racionalidade",
        "Realidade",
        "Recanto",
        "Reclinável",
        "Reconhecimento",
        "Recordação",
        "Reflexo",
        "Reflexão",
        "Relógio",
        "Reptil",
        "Resiliência",
        "Respeito",
        "Respirar",
        "Rio",
        "Riqueza",
        "Risada",
        "Riso",
        "Rosa",
        "Roubar",
        "Rua",
        "Sabedoria",
        "Sabor",
        "Sabores",
        "Sapato",
        "Selva",
        "Sentar",
        "Serenidade",
        "Serpente",
        "Silêncio",
        "Simplicidade",
        "Software",
        "Sofá",
        "Sol",
        "Solidão",
        "Sombra",
        "Sombrero",
        "Sonho",
        "Sorriso",
        "Sorvete",
        "Superação",
        "Sussurro",
        "Tartaruga",
        "Teclado",
        "Tela",
        "Telefone",
        "Tempo",
        "Ternura",
        "Terra",
        "Tesouro",
        "Tigre",
        "Tolerância",
        "Trabalho",
        "Tranquilidade",
        "Transcendência",
        "Transformação",
        "Trapaceiro",
        "Tremor",
        "Universo",
        "Urso",
        "Ventania",
        "Vento",
        "Ver",
        "Verdade",
        "Verão",
        "Vestido",
        "Viagem",
        "Vinho",
        "Vulnerabilidade",
        "Zebra",
        "Águia",
        "Ártico",
        "Árvore",
        "Ética",
        "﻿Amargo",
        "﻿﻿﻿﻿﻿Amigo",
        "﻿﻿﻿﻿﻿Animal",
        "﻿﻿﻿﻿﻿Antenas",
        "﻿﻿﻿﻿﻿Aracnídeo",
        "﻿﻿﻿﻿﻿Arma",
        "﻿﻿﻿﻿﻿Azedo",
        "﻿﻿﻿﻿﻿Azul",
        "﻿﻿﻿﻿﻿Bala",
        "﻿﻿﻿﻿﻿Balançando",
        "﻿﻿﻿﻿﻿Banco",
        "﻿﻿﻿﻿﻿Banda",
        "﻿﻿﻿﻿﻿Bandido",
        "﻿﻿﻿﻿﻿Banqueta",
        "﻿﻿﻿﻿﻿Barba",
        "﻿﻿﻿﻿﻿Bocejar",
        "﻿﻿﻿﻿﻿Bolo",
        "﻿﻿﻿﻿﻿Bom",
        "﻿﻿﻿﻿﻿Bonito",
        "﻿﻿﻿﻿﻿Branco",
        "﻿﻿﻿﻿﻿Buzinar",
        "﻿﻿﻿﻿﻿Cansado",
        "﻿﻿﻿﻿﻿Cantar",
        "﻿﻿﻿﻿﻿Carvão",
        "﻿﻿﻿﻿﻿Cavalheiro",
        "﻿﻿﻿﻿﻿Cinza",
        "﻿﻿﻿﻿﻿Cobertor",
        "﻿﻿﻿﻿﻿Cochilo",
        "﻿﻿﻿﻿﻿Concerto",
        "﻿﻿﻿﻿﻿Cor",
        "﻿﻿﻿﻿﻿Crime",
        "﻿﻿﻿﻿﻿Criminoso",
        "﻿﻿﻿﻿﻿Dama",
        "﻿﻿﻿﻿﻿Dente",
        "﻿﻿﻿﻿﻿Despertador",
        "﻿﻿﻿﻿﻿Encosto",
        "﻿﻿﻿﻿﻿Escuro",
        "﻿﻿﻿﻿﻿Estofado",
        "﻿﻿﻿﻿﻿Forte",
        "﻿﻿﻿﻿﻿Fundo",
        "﻿﻿﻿﻿﻿Funeral",
        "﻿﻿﻿﻿﻿Giratória",
        "﻿﻿﻿﻿﻿Gostoso",
        "﻿﻿﻿﻿﻿Horripilante",
        "﻿﻿﻿﻿﻿Inseto",
        "﻿﻿﻿﻿﻿Instrumento",
        "﻿﻿﻿﻿﻿Jazz",
        "﻿﻿﻿﻿﻿Luto",
        "﻿﻿﻿﻿﻿Marido",
        "﻿﻿﻿﻿﻿Marron",
        "﻿﻿﻿﻿﻿Masculino",
        "﻿﻿﻿﻿﻿Medo",
        "﻿﻿﻿﻿﻿Mel",
        "﻿﻿﻿﻿﻿Morte",
        "﻿﻿﻿﻿﻿Mulher",
        "﻿﻿﻿﻿﻿Músculo",
        "﻿﻿﻿﻿﻿Nota",
        "﻿﻿﻿﻿﻿Orquestra",
        "﻿﻿﻿﻿﻿Pai",
        "﻿﻿﻿﻿﻿Paz",
        "﻿﻿﻿﻿﻿Pequeno",
        "﻿﻿﻿﻿﻿Percevejo",
        "﻿﻿﻿﻿﻿Pessoa",
        "﻿﻿﻿﻿﻿Piano",
        "﻿﻿﻿﻿﻿Picada",
        "﻿﻿﻿﻿﻿Pudim",
        "﻿﻿﻿﻿﻿Queimado",
        "﻿﻿﻿﻿﻿Rastejar",
        "﻿﻿﻿﻿﻿Refrigerante",
        "﻿﻿﻿﻿﻿Ritmo",
        "﻿﻿﻿﻿﻿Ronco",
        "﻿﻿﻿﻿﻿Rádio",
        "﻿﻿﻿﻿﻿Sentado",
        "﻿﻿﻿﻿﻿Sesta",
        "﻿﻿﻿﻿﻿Sinfonia",
        "﻿﻿﻿﻿﻿Som",
        "﻿﻿﻿﻿﻿Soneca",
        "﻿﻿﻿﻿﻿Sono",
        "﻿﻿﻿﻿﻿Sonolento",
        "﻿﻿﻿﻿﻿Tarântula",
        "﻿﻿﻿﻿﻿Teia",
        "﻿﻿﻿﻿﻿Terno",
        "﻿﻿﻿﻿﻿Tinta",
        "﻿﻿﻿﻿﻿Tio",
        "﻿﻿﻿﻿﻿Torta",
        "﻿﻿﻿﻿﻿Velho",
        "﻿﻿﻿﻿﻿Veneno",
        "﻿﻿﻿﻿﻿Vilão",
        "﻿﻿﻿﻿﻿Voar"
    ]
    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadFromUserDefaults()
        setupBindings()
        
        if let ultimaVisitaData = UserDefaults.standard.object(forKey: "UltimaVisita") as? Date {
            self.ultimaVisita = ultimaVisitaData
        }

        if UserDefaults.standard.string(forKey: "PalavraDoDia") == nil {
            gerarNovaPalavra()
        } else {
            self.palavraDoDia = UserDefaults.standard.string(forKey: "PalavraDoDia")
        }
        self.palavrasUsadas = UserDefaults.standard.stringArray(forKey: "PalavrasUsadas") ?? []
        
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
           let encodedEstrelasExpiradas = try? encoder.encode(estrelasExpiradas) {
            UserDefaults.standard.set(encodedEstrelas, forKey: "todasEstrelas")
            UserDefaults.standard.set(encodedEstrelasExpiradas, forKey: "estrelasExpiradas")
            print("Salvo.")
            print(todasEstrelas)
        } else {
            print("Erro ao codificar e salvar dados no UserDefaults.")
        }
    }

    func loadFromUserDefaults() {
        let decoder = JSONDecoder()
        
        if let savedEstrelas = UserDefaults.standard.object(forKey: "todasEstrelas") as? Data,
           let savedEstrelasExpiradas = UserDefaults.standard.object(forKey: "estrelasExpiradas") as? Data {
            do {
                let loadedEstrelas = try decoder.decode([Estrela].self, from: savedEstrelas)
                let loadedEstrelasExpiradas = try decoder.decode([Estrela].self, from: savedEstrelasExpiradas)
                todasEstrelas = loadedEstrelas
                estrelasExpiradas = loadedEstrelasExpiradas
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
            estrelasExpiradas.append(estrela)
            print(estrelasExpiradas)
            saveToUserDefaults()
        }
    }
    
    func addEstrelaExpirada(_ estrela: Estrela) {
        if !estrela.isAlive {
            print("Estrela expirada adicionada \(estrela)")
            estrelasExpiradas.append(estrela)
            saveToUserDefaults()
        }
        
    }

    func updateEstrela(_ updatedEstrela: Estrela) {
        guard let index = todasEstrelas.firstIndex(where: { $0.id == updatedEstrela.id }) else {
            return
        }
        print("Estrela atualizada")
        todasEstrelas[index] = updatedEstrela
        print(todasEstrelas[index])
        saveToUserDefaults()
        
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
            let endDate = estrela.dataInicio.addingTimeInterval(estrela.addDuracao())
            return currentDate > endDate
        }

        todasEstrelas = todasEstrelas.filter { estrela in
            let endDate = estrela.dataInicio.addingTimeInterval(estrela.addDuracao())
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
    
    func obterPalavraDoDia() {
        let agora = Date()
        guard let ultimaDataGerada = ultimaDataGerada else {
            // Se não tiver uma data de última geração, gera uma nova palavra
            gerarNovaPalavra()
            return
        }

        let intervalo = agora.timeIntervalSince(ultimaDataGerada)
        if intervalo >= 86400 { // 86400 segundos = 24 horas
            // Se passaram 24 horas desde a última geração, gera uma nova palavra
            gerarNovaPalavra()
        }
    }

    private func gerarNovaPalavra() {
        if let palavraAleatoria = palavras.filter({ !palavrasUsadas.contains($0) }).randomElement() {
            palavraDoDia = palavraAleatoria
            palavrasUsadas.append(palavraAleatoria)
            ultimaDataGerada = Date() // Atualiza a data da última geração para agora
        } else {
            // Resetar a lista de palavras usadas se todas as palavras já foram usadas
            palavrasUsadas.removeAll()
        }
    }
    
    func tipoAleatorio() -> TipoEstrela {
        let tipos = TipoEstrela.allCases
        return tipos.randomElement()!
    }
    
}
