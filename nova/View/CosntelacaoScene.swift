import Foundation
import SpriteKit

class ConstelacaoScene: SKScene, EstrelaDelegate {

    

    private var estrelaOriginal: Estrela?
    private var todasEstrelas: [Estrela] = []
    private var cameraNode = SKCameraNode()
    var labelInfo: SKLabelNode!
    let distanciaNovaEstrela: CGFloat = 500
    var previousCameraScale = CGFloat()
    private var lastPanLocation: CGPoint?
    var pinchGesture: UIPinchGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    var rotateGesture: UIRotationGestureRecognizer!
    private var ui = SKShapeNode()
    var lastUpdateTime: TimeInterval?

    
    override func didMove(to view: SKView) {
        // Definir o fundo como preto
        self.backgroundColor = SKColor.black
        anchorPoint = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        ui = SKShapeNode(rectOf: CGSize(width: view.bounds.width * 4.4, height: view.bounds.height * 4.4))
        ui.zPosition = 2
        ui.strokeColor = .clear
        
        // Setting game camera
        cameraNode.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        cameraNode.setScale(0.5)
        camera = cameraNode
//        cameraNode.addChild(ui)
        addChild(cameraNode)
        
        // Adicionar estrela no centro
        estrelaOriginal = adicionarEstrela(x: Double(self.size.width / 2), y: Double(self.size.height / 2))
        todasEstrelas.append(estrelaOriginal!)
        labelInfo = SKLabelNode(text: "")
        labelInfo.fontSize = 14
        labelInfo.fontColor = .white
        labelInfo.position = CGPoint(x: self.size.width / 2, y: self.size.height - 50) // Topo da tela
        self.addChild(labelInfo)

        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction(_:)))
        view.addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = self

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        panGesture.delegate = self

        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateGestureAction(_:)))
        view.addGestureRecognizer(rotateGesture)
        rotateGesture.delegate = self
    }
    
    func adicionarEstrela(x: CGFloat, y: CGFloat, texto: String = "Nome", tamanho: CGSize? = nil) -> Estrela {
        let size = tamanho ?? CGSize(width: 20, height: 20)
        let estrela = Estrela(texto: texto, x: x, y: y,tamanho: size)
        estrela.delegate = self
        estrela.position = CGPoint(x: x, y: y)
        self.addChild(estrela)
        return estrela
    }
    
    func conectarEstrelas(estrela1: Estrela, estrela2: Estrela) {
        let path = UIBezierPath()
        path.move(to: estrela1.position)
        path.addLine(to: estrela2.position)

        let linha = SKShapeNode(path: path.cgPath)
        linha.strokeColor = SKColor.gray.withAlphaComponent(transparenciaParaNivel(estrela1.nivel))
        linha.zPosition = -1
        self.addChild(linha)
    }

    func transparenciaParaNivel(_ nivel: Int) -> CGFloat {
        return 1.0 - CGFloat(nivel) * 0.4
    }

    func posicaoEhValida(x: CGFloat, y: CGFloat) -> Bool {
        let novaPosicao = CGPoint(x: x, y: y)
        for estrela in todasEstrelas {
            if estrela.position.distance(to: novaPosicao) < 50 {
                return false
            }
        }
        return true
    }
    
    func calcularNovaPosicao(estrela: Estrela, tempoPassado: CGFloat) -> CGPoint {
        guard let estrelaOrigem = estrela.estrelaOrigem else {
            return estrela.position
        }
        let raio = estrelaOrigem.position.distance(to: estrela.position)
        let anguloInicial = anguloEntre(ponto1: estrelaOrigem.position, ponto2: estrela.position)
        let velocidadeAngular = CGFloat.pi/180 // 1 grau por segundo
        let anguloNovo = anguloInicial + velocidadeAngular * tempoPassado
        let novoX = estrelaOrigem.position.x + cos(anguloNovo) * raio
        let novoY = estrelaOrigem.position.y + sin(anguloNovo) * raio
        
        return CGPoint(x: novoX, y: novoY)
    }
    
    func distanciaMaximaParaNivel(_ nivel: Int) -> CGFloat {
        switch nivel {
        case 0: return 500
        case 1: return 200
        case 2: return 100
        default: return 50
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Se o pinchGesture estiver ativo, desative os outros gestures
        if gestureRecognizer == pinchGesture || otherGestureRecognizer == pinchGesture {
            return false
        }
        return true
    }
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        let translationInView = sender.translation(in: self.view)
        let angle = camera.zRotation
        let rotatedTranslation = CGPoint(x: cos(angle) * translationInView.x + sin(angle) * translationInView.y,
                                         y: -sin(angle) * translationInView.x + cos(angle) * translationInView.y)
        let translationInScene = CGPoint(x: rotatedTranslation.x * -camera.xScale, y: rotatedTranslation.y * camera.yScale)
        camera.position = CGPoint(x: camera.position.x + translationInScene.x, y: camera.position.y + translationInScene.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    @objc func rotateGestureAction(_ sender: UIRotationGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        camera.zRotation += sender.rotation
        sender.rotation = 0
    }
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        let minScale: CGFloat = 0.2
        let maxScale: CGFloat = 5.0
        var newScale = camera.xScale * (1.0/(sender.scale))
        newScale = max(minScale, min(maxScale, newScale))
        camera.setScale(newScale)
        sender.scale = 1.0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Chamado antes de cada quadro ser renderizado
        let tempoPassado = CGFloat(currentTime - (self.lastUpdateTime ?? currentTime))
        self.lastUpdateTime = currentTime
        
        for estrela in todasEstrelas {
            if estrela.nivel > 1{
                guard estrela != estrelaOriginal else {
                continue
            }
            
            estrela.position = calcularNovaPosicao(estrela: estrela, tempoPassado: tempoPassado)
        }}
    }
    
    func criarEConectarNovaEstrela(_ estrela: Estrela) {
        guard estrela.nivel < 3 else {
            return
        }

        let distanciaMax = distanciaMaximaParaNivel(estrela.nivel)
        var x: CGFloat = 0
        var y: CGFloat = 0
        var angulo: CGFloat = 0

        angulo = CGFloat.random(in: 0...2 * .pi)

        repeat {
            x = estrela.position.x + cos(angulo) * CGFloat.random(in: (distanciaMax/2)...distanciaMax)
            y = estrela.position.y + sin(angulo) * CGFloat.random(in: (distanciaMax/2)...distanciaMax)
        } while !posicaoEhValida(x: x, y: y)

        let tamanhoEstrela = CGSize(width: estrela.frame.width/2, height: estrela.frame.height/2)
        let novaEstrela = adicionarEstrela(x: Double(x), y: Double(y), texto: "AlgumTexto", tamanho: tamanhoEstrela)
        novaEstrela.nivel = estrela.nivel + 1
        novaEstrela.estrelaOrigem = estrela
        todasEstrelas.append(novaEstrela)
        conectarEstrelas(estrela1: estrela, estrela2: novaEstrela)
    }

}
extension ConstelacaoScene: UIGestureRecognizerDelegate {
    func anguloEntre(ponto1: CGPoint, ponto2: CGPoint) -> CGFloat {
        let deltaY = ponto2.y - ponto1.y
        let deltaX = ponto2.x - ponto1.x
        return atan2(deltaY, deltaX)
    }
    func estrelaTocada(_ estrela: Estrela) {
        
    }
}


extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}


