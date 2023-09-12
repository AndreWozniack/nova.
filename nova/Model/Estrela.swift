
import Foundation
import SpriteKit

protocol EstrelaDelegate: AnyObject {
    func estrelaTocada(_ estrela: Estrela)
}

class Estrela: SKShapeNode, Codable{

    @Published var tempoRestanteString: String = ""
    weak var delegate: EstrelaDelegate?
    var id  = UUID()
    var reflexao: Reflexao
    var nivel: Int = 0
    var x: CGFloat
    var y: CGFloat
    var estrelaOrigem: UUID?
    var dataInicio: Date
    var duracao: TimeInterval?  // 30 dias em segundos
    var tipo : TipoEstrela?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current // Use a localização atual do dispositivo
        return formatter
    }
    var isAlive : Bool
    var updateTimer: Timer?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case conexoes = "conexoes"
        case reflexao = "reflexao"
        case nivel = "nivel"
        case x = "x"
        case y = "y"
        case estrelaOrigem = "estrelaOrigem"
        case dataInicio = "dataInicio"
        case isAlive = "isAlive"
        case tipo = "tipo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.reflexao = try container.decode(Reflexao.self, forKey: .reflexao)
        self.nivel = try container.decode(Int.self, forKey: .nivel)
        self.x = try container.decode(CGFloat.self, forKey: .x)
        self.y = try container.decode(CGFloat.self, forKey: .y)
        self.estrelaOrigem = try container.decodeIfPresent(UUID.self, forKey: .estrelaOrigem)
        self.dataInicio = try container.decode(Date.self, forKey: .dataInicio)
        self.isAlive = try container.decode(Bool.self, forKey: .isAlive)
        self.tipo = try container.decode(TipoEstrela.self, forKey: .tipo)
        super.init()
        self.position = CGPoint(x: x, y: y)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(reflexao, forKey: .reflexao)
        try container.encode(nivel, forKey: .nivel)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(estrelaOrigem, forKey: .estrelaOrigem)
        try container.encode(dataInicio, forKey: .dataInicio)
        try container.encode(isAlive, forKey: .isAlive)
        try container.encode(tipo!.rawValue, forKey: .tipo)
    }
    
    init(reflexao: Reflexao, x: CGFloat, y: CGFloat, origem: Estrela? = nil, tipo: TipoEstrela?) {
        self.reflexao = reflexao
        self.x = x
        self.y = y
        self.dataInicio = Date()
        self.isAlive = true
        super.init()

        
        self.estrelaOrigem = origem?.id  // Inicializando com o valor fornecido (pode ser nil)
        self.tipo = tipo
        self.duracao = addDuracao()
        
        let tamanho : CGFloat = addTamanho()
        let circle = SKShapeNode(circleOfRadius: tamanho / 2)
        circle.fillColor = .white
        addGlow(to: circle, radius: Float(tamanho), tipo: self.tipo!)
        addChild(circle)
        


        self.position = CGPoint(x: x, y: y)
        self.isUserInteractionEnabled = true
        startUpdateTimer()
    }
    
    func getDuracao() -> String {
        return formatTimeInterval(duracao!)
    }
    
    convenience override init() {
        self.init(reflexao: Reflexao(titulo: "", texto: ""), x: 0, y: 0, tipo: EstrelaManager.shared.tipoAleatorio())
    }

    func tipoAleatorio() -> TipoEstrela {
        let tipos = [TipoEstrela.anaAmarela, TipoEstrela.anaBranca, TipoEstrela.giganteAzul, TipoEstrela.giganteVermelha]
        return tipos.randomElement()!
    }
    
    override var description: String {
        return "=============\nTipo = \(tipo?.rawValue ?? "SEM TIPO")\nID = \(id)\nTema = \(reflexao.titulo)\nReflexão = \(reflexao.texto)\nData de Criação = \(dateFormatter.string(from: dataInicio))\nTempo Restante = \(formatTimeInterval(tempoRestante(dataInicio)))\nNivel = \(nivel)\nx:\(x) y:\(y)\nEstrela de origem: \(estrelaOrigem?.uuidString ?? "Sem origem") \n=============\n"
    }

    func transparenciaParaNivel(_ nivel: Int) -> CGFloat {
        return CGFloat(nivel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.estrelaTocada(self)
    }
    
    func tempoRestante(_ data: Date) -> TimeInterval {
        dateFormatter.string(from: data)
        let endDate = dataInicio.addingTimeInterval(duracao!)
        return endDate.timeIntervalSince(Date())
    }
    
    func formatTimeInterval(_ tempo: TimeInterval) -> String {
        let interval = Int(tempo)
        let days = interval / (24 * 3600)
        let hours = (interval % (24 * 3600)) / 3600
        let minutes = (interval % 3600) / 60
        if days == 0 {
            if hours == 0{
                return "\(minutes) minutos"
            }
            return "\(hours) horas, \(minutes) minutos"
        }
        if hours == 0 {
            return "\(days) dias"
        }
        return "\(days) dias, \(hours) horas, \(minutes) minutos"
    }

    
    func startUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    func updateTime() {
        checkIfAlive()
        if isAlive {
            tempoRestanteString = formatTimeInterval(tempoRestante(dataInicio))
        } else {
            if !EstrelaManager.shared.estrelasExpiradas.contains(where: { $0.id == self.id }) {
                EstrelaManager.shared.addEstrelaExpirada(self)
            }
            tempoRestanteString = "Essa estrela não está mais viva."
            updateTimer?.invalidate()
        }
    }

    
    func checkIfAlive() {
        let endDate = dataInicio.addingTimeInterval(duracao!)
        isAlive = Date() <= endDate
    }
    
    func addDuracao() -> TimeInterval {
        switch tipo {
        case .anaAmarela:
            duracao = 30 * 24 * 60 * 60
            return 30 * 24 * 60 * 60
        case .giganteVermelha:
            duracao = 60 * 24 * 60 * 60
            return 60 * 24 * 60 * 60
        case .giganteAzul:
            duracao = 90 * 24 * 60 * 60
            return 90 * 24 * 60 * 60
        case .anaBranca:
            duracao = 15 * 24 * 60 * 60
            return 15 * 24 * 60 * 60
        case .none:
            duracao = 30 * 24 * 60 * 60
            return 30 * 24 * 60 * 60
        }
    }
    
    func addTamanho() -> CGFloat {
        switch tipo! {
        case .giganteVermelha :
            return 120
        case .giganteAzul:
            return 80
        case .anaAmarela:
            return 40
        case .anaBranca:
            return 30
        }
    }
    
    func getIcon() -> String {
        switch tipo! {
        case .giganteVermelha :
            return "giganteVermelha"
        case .giganteAzul:
            return "giganteAzul"
        case .anaAmarela:
            return "anaAmarela"
        case .anaBranca:
            return "anaBranca"
        }
        
    }
    
    private func addGlow(to node: SKShapeNode, radius: Float, tipo : TipoEstrela) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        self.addChild(effectNode)
        effectNode.position = node.position

        let texture = SKView().texture(from: node)
        let effect = SKSpriteNode(texture: texture)
        
        switch tipo {
        case .anaAmarela:
            effect.color = .yellow
        case .giganteVermelha:
            effect.color = .red
        case .giganteAzul:
            effect.color = .blue
        case .anaBranca:
            effect.color = .white
        }
        
        effect.colorBlendFactor = 2
        effectNode.addChild(effect)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
}

enum TipoEstrela: String, Codable {
    case giganteVermelha = "Gigante Vermelha"
    case giganteAzul = "Gigante Azul"
    case anaAmarela = "Anã Amarela"
    case anaBranca = "Anã Branca"
}
