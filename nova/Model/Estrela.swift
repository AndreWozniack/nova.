
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
    var duracao: TimeInterval =  3600 //30 * 24 * 60 * 60  // 30 dias em segundos
    
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
    }
    
    init(reflexao: Reflexao, x: CGFloat, y: CGFloat, tamanho: CGFloat = 40, origem: Estrela? = nil) {
        self.reflexao = reflexao
        self.x = x
        self.y = y
        self.dataInicio = Date()
        self.isAlive = true
        super.init()

        self.estrelaOrigem = origem?.id  // Inicializando com o valor fornecido (pode ser nil)

        let circle = SKShapeNode(circleOfRadius: tamanho / 2)
        circle.fillColor = .white
        addGlow(to: circle, radius: Float(tamanho)*1.5)
        addChild(circle)
        


        self.position = CGPoint(x: x, y: y)
        self.isUserInteractionEnabled = true
        startUpdateTimer()
    }
    
    convenience override init() {
        self.init(reflexao: Reflexao(titulo: "", texto: ""), x: 0, y: 0)
    }

    
    override var description: String {
        return "=============\nID = \(id)\nTema = \(reflexao.titulo)\nReflexão = \(reflexao.texto)\nData de Criação = \(dateFormatter.string(from: dataInicio))\nTempo Restante = \(formatTimeInterval(tempoRestante(dataInicio)))\nNivel = \(nivel)\nx:\(x) y:\(y)\nEstrela de origem: \(estrelaOrigem?.uuidString ?? "Sem origem") \n=============\n"
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
        let endDate = dataInicio.addingTimeInterval(duracao)
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
            tempoRestanteString = "Essa estrela não está mais viva."
            updateTimer?.invalidate() // Pare o timer se a estrela não estiver mais viva
        }
    }
    
    func checkIfAlive() {
        let endDate = dataInicio.addingTimeInterval(duracao)
        isAlive = Date() <= endDate
    }
    
    private func addGlow(to node: SKShapeNode, radius: Float = 40) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        self.addChild(effectNode)
        effectNode.position = node.position

        let texture = SKView().texture(from: node)
        let effect = SKSpriteNode(texture: texture)
        effect.color = .white //Fazer cor variar conforme o tipo
        effect.colorBlendFactor = 1
        effectNode.addChild(effect)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
}




