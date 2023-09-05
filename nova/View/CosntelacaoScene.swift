import Foundation
import SpriteKit
import Combine

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
    var longPressGesture : UILongPressGestureRecognizer!
    private var ui = SKShapeNode()
    var lastUpdateTime: TimeInterval?
    var cancellable = Set<AnyCancellable>()
    
    

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
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1
        view.addGestureRecognizer(longPressGesture)
        longPressGesture.delegate = self
        
        initSink()
        
    }
    
    func initSink() {
        Manager.shared.$estrela.sink { estrela in
            if estrela.reflexao.texto != "" {
                self.estrelaCriada(estrela)
            }
        }.store(in: &cancellable)
    }
    
    
    func adicionarEstrela(titulo: String, texto: String, nivel: Int, x: CGFloat, y: CGFloat, tamanho: CGSize? = nil) -> Estrela {
        let reflexao = Reflexao(titulo: titulo, texto: texto)
        let estrela = Estrela(reflexao: reflexao, x: x, y: y)
        estrela.nivel = nivel
        estrela.delegate = self
        estrela.position = CGPoint(x: x, y: y)
        estrela.zPosition = 1
        self.addChild(estrela)
        return estrela
    }
    func conectarEstrelas(estrela1: Estrela, estrela2: Estrela) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: estrela1.x, y: estrela1.y))
        path.addLine(to: CGPoint(x: estrela2.x, y: estrela2.y))
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
    func distanciaMaximaParaNivel(_ nivel: Int) -> CGFloat {
        switch nivel {
        case 0: return 500
        case 1: return 200
        case 2: return 100
        default: return 50
        }
    }
    
    func estrelaTocada(_ estrela: Estrela) {
        print(estrela)
        Manager.shared.estrelaTocada = estrela
        Manager.shared.showNewView = true
        

    }
    func criarNovaEstrelaBaseadaEm(_ estrela: Estrela) -> Estrela {
        let distanciaMax = distanciaMaximaParaNivel(estrela.nivel)
        var x: CGFloat = 0
        var y: CGFloat = 0
        var angulo: CGFloat = 0
        angulo = CGFloat.random(in: 0...2 * .pi)
        repeat {
            x = estrela.x + cos(angulo) * CGFloat.random(in: (distanciaMax/2)...distanciaMax)
            y = estrela.y + sin(angulo) * CGFloat.random(in: (distanciaMax/2)...distanciaMax)
        } while !posicaoEhValida(x: x, y: y)
        let novaEstrela = adicionarEstrela(titulo: estrela.reflexao.titulo, texto: estrela.reflexao.texto, nivel: estrela.nivel, x: x, y: y)
        novaEstrela.nivel = estrela.nivel + 1
        novaEstrela.estrelaOrigem = estrela.id
        todasEstrelas.append(novaEstrela)
        return novaEstrela
    }

    
    func estrelaCriada(_ estrela: Estrela) {
        let distanciaMax = distanciaMaximaParaNivel(estrela.nivel)
        var x: CGFloat = 0
        var y: CGFloat = 0
        var angulo: CGFloat = 0
        angulo = CGFloat.random(in: 0...2 * .pi)
        repeat {
            x = estrela.x + cos(angulo) * CGFloat.random(in: (distanciaMax/2)...distanciaMax)
            y = estrela.y + sin(angulo) * CGFloat.random(in: (distanciaMax/2)...distanciaMax)
        } while !posicaoEhValida(x: x, y: y)
        let novaEstrela = adicionarEstrela(titulo: estrela.reflexao.titulo, texto: estrela.reflexao.texto, nivel: estrela.nivel, x: x, y: y)
        novaEstrela.nivel = estrela.nivel + 1
        novaEstrela.estrelaOrigem = estrela.id
        todasEstrelas.append(novaEstrela)
    }
    
        
    // MARK: - Gestos
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
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let locationInView = sender.location(in: self.view)
            let locationInScene = convertPoint(fromView: locationInView)
            if posicaoEhValida(x: locationInScene.x, y: locationInScene.y) {
                Manager.shared.showView = true
                Manager.shared.estrela = Estrela(reflexao: Reflexao(titulo: "", texto: ""), x: Double(locationInScene.x), y: Double(locationInScene.y))
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pinchGesture || otherGestureRecognizer == pinchGesture {
            return false
        }
        return true
    }

}
extension ConstelacaoScene: UIGestureRecognizerDelegate {
    func anguloEntre(ponto1: CGPoint, ponto2: CGPoint) -> CGFloat {
        let deltaY = ponto2.y - ponto1.y
        let deltaX = ponto2.x - ponto1.x
        return atan2(deltaY, deltaX)
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}


