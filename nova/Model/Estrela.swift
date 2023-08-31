import Foundation
import SpriteKit

protocol EstrelaDelegate {
    func estrelaTocada(_ estrela: Estrela)
}

class Estrela: SKShapeNode {
    
    var delegate: EstrelaDelegate?
    var texto: String?
    var conexoes: [Estrela] = []
    var x : CGFloat
    var y : CGFloat
    var nivel: Int = 0 {
        didSet {
            self.fillColor = corParaNivel(nivel)
            self.strokeColor = self.fillColor.withAlphaComponent(transparenciaParaNivel(nivel))
        }
    }
    weak var estrelaOrigem: Estrela?  // Adicionando a propriedade estrelaOrigem
    var tema: Tema?  // Adicionando a propriedade tema
    var reflexao: Reflexao?  // Adicionando a propriedade reflexao
    
    init(texto: String, x: CGFloat, y: CGFloat, tamanho: CGSize = CGSize(width: 50, height: 50), origem: Estrela? = nil) {
        self.texto = texto
        self.x = x
        self.y = y
        self.estrelaOrigem = origem
        
        super.init()
        
        self.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -tamanho.width/2, y: -tamanho.height/2), size: tamanho)).cgPath
        self.fillColor = .white
        self.position = CGPoint(x: x, y: y)
        self.isUserInteractionEnabled = true
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
    }
}
