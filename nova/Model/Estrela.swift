
import Foundation
import SpriteKit

protocol EstrelaDelegate: AnyObject {
    func estrelaTocada(_ estrela: Estrela)
}

class Estrela: SKShapeNode, Codable{

    weak var delegate: EstrelaDelegate?
    var id  = UUID()
    var conexoes: [UUID] = []
    var reflexao: Reflexao
    var nivel: Int = -1 {
        didSet {
            self.fillColor = corParaNivel(nivel)
            self.strokeColor = self.fillColor.withAlphaComponent(transparenciaParaNivel(nivel))
        }
    }
    var x: CGFloat
    var y: CGFloat
    var estrelaOrigem: UUID?
    var dataInicio: Date
    var duracao: TimeInterval = 30 * 24 * 60 * 60  // 30 dias em segundos

    
    enum CodingKeys: String, CodingKey {
        case id
        case conexoes
        case reflexao
        case nivel
        case x
        case y
        case estrelaOrigem
        case dataInicio
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conexoes = try container.decode([UUID].self, forKey: .conexoes)
        self.reflexao = try container.decode(Reflexao.self, forKey: .reflexao)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.nivel = try container.decode(Int.self, forKey: .nivel)
        self.x = try container.decode(CGFloat.self, forKey: .x)
        self.y = try container.decode(CGFloat.self, forKey: .y)
        self.estrelaOrigem = try container.decode(UUID?.self, forKey: .estrelaOrigem)
        self.dataInicio = try container.decode(Date.self, forKey: .dataInicio)
        super.init()
        self.position = position
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(conexoes, forKey: .conexoes)
        try container.encode(reflexao, forKey: .reflexao)
        try container.encode(nivel, forKey: .nivel)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(estrelaOrigem, forKey: .estrelaOrigem)
    }
    
    init(reflexao: Reflexao,x: CGFloat ,y: CGFloat ,tamanho: CGSize = CGSize(width: 5, height: 5), origem: UUID? = nil) {
        self.reflexao = reflexao
        self.x = x
        self.y = y
        self.dataInicio = Date()
        super.init()
        
        self.estrelaOrigem = origem  // Inicializando com o valor fornecido (pode ser nil)
        self.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -tamanho.width/2, y: -tamanho.height/2), size: tamanho)).cgPath
        self.fillColor = .white
        self.isUserInteractionEnabled = true
    }
    
    convenience override init() {
        self.init(reflexao: Reflexao(titulo: "", texto: ""), x: 0, y: 0)
    }

    
    override var description: String {
        return "=============\nID = \(id)\nTema = \(reflexao.titulo)\nReflexão = \(reflexao.texto)\nData de Criação = \(dataInicio)\nTempo Restante = \(formatTimeInterval())\nNivel = \(nivel)\nx:\(x) y:\(y)\n=============\n"
    }
    
    func corParaNivel(_ nivel: Int) -> UIColor {
        switch nivel {
        case 0:
            return .white
        case 1:
            return .green
        case 2:
            return .red
        default:
            return .blue
        }
    }

    func transparenciaParaNivel(_ nivel: Int) -> CGFloat {
        return CGFloat(nivel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.estrelaTocada(self)
//        print(self)
    }
    
    func tempoRestante() -> TimeInterval {
        let endDate = dataInicio.addingTimeInterval(duracao)
        return endDate.timeIntervalSince(Date())
    }
    
    func formatTimeInterval() -> String {
        let interval = Int(tempoRestante())
        let days = interval / (24 * 3600)
        let hours = (interval % (24 * 3600)) / 3600
        let minutes = (interval % 3600) / 60
        return "\(days) dias, \(hours) horas, \(minutes) minutos"
    }
}

