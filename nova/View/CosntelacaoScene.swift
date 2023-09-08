import Foundation
import SpriteKit
import Combine

class ConstelacaoScene: SKScene, EstrelaDelegate {
    
    private var estrelaOriginal: Estrela?
    private var todasEstrelas: [Estrela] = []
    private var cameraNode = SKCameraNode()
    var pinchGesture: UIPinchGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    var rotateGesture: UIRotationGestureRecognizer!
    var longPressGesture : UILongPressGestureRecognizer!
    var cancellable = Set<AnyCancellable>()
    var panVelocity: CGPoint = .zero
    
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        anchorPoint = CGPoint(x: 0, y: 0)
        
        cameraNode.position = anchorPoint
        cameraNode.setScale(1)
        camera = cameraNode
        addChild(cameraNode)
        
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
        setConstelacoes()
        
        if let ultimaEstrela = EstrelaManager.shared.todasEstrelas.last {
            cameraNode.position = CGPoint(x: ultimaEstrela.x, y: ultimaEstrela.y)
        }
    }
    
    func initSink() {
        Manager.shared.$estrela.sink { estrela in
            if estrela.reflexao.texto != "" {
                if estrela.nivel > 0{
                    self.estrelaCriada(estrela)
                    self.todasEstrelas.append(estrela)
                    
                }
                
                self.estrelaCriada(estrela)
            }
        }.store(in: &cancellable)
        
        Manager.shared.$subEstrela.sink { subEstrela in
            if subEstrela.reflexao.texto != "" {
                self.estrelaCriada(subEstrela)
                if let estrelaOrigemID = subEstrela.estrelaOrigem,let estrelaOrigem = self.todasEstrelas.first(where: { $0.id == estrelaOrigemID }) {
                    print(estrelaOrigem)
                    self.addChild(subEstrela)
                }
            }
        }.store(in: &cancellable)
    }
    
    func tamanhoNivel(_ nivel:Int) -> CGFloat{
        switch nivel {
        case 0:
            return CGFloat(40)
        case 1:
            return CGFloat(30)
        case 2:
            return CGFloat(20)
        case 3:
            return CGFloat(10)
        default:
            return CGFloat(40)
        }
    }
    func tamanhoTituloNivel(_ nivel:Int) -> CGFloat{
        switch nivel {
        case 0:
            return CGFloat(20)
        case 1:
            return CGFloat(15)
        case 2:
            return CGFloat(10)
        case 3:
            return CGFloat(5)
        default:
            return CGFloat(20)
        }
    }
    
    
    func adicionarEstrelaNaTela(_ estrela: Estrela) -> Estrela {
        let novaEstrela = Estrela(reflexao: estrela.reflexao, x: estrela.x, y: estrela.y, tamanho: tamanhoNivel(estrela.nivel))
        novaEstrela.nivel = estrela.nivel
        novaEstrela.delegate = self
        novaEstrela.position = CGPoint(x: estrela.x, y: estrela.y)
        novaEstrela.zPosition = 1
        self.addChild(novaEstrela)
        
        novaEstrela.dataInicio = estrela.dataInicio
        novaEstrela.id = estrela.id
        novaEstrela.isAlive = estrela.isAlive
        novaEstrela.estrelaOrigem = estrela.estrelaOrigem
        
        if estrela.nivel == 0 {
            addTitulo(novaEstrela)
        }
        todasEstrelas.append(novaEstrela)
        
        return novaEstrela
    }
    
    func addTitulo(_ estrela: Estrela) {
        let titleLabel = SKLabelNode(text: estrela.reflexao.titulo)
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = 12 // Ajuste o tamanho da fonte conforme necessário
        titleLabel.position = CGPoint(x: 0, y: tamanhoNivel(estrela.nivel)) // Posicione o título abaixo do círculo
        estrela.addChild(titleLabel)
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
        case 0: return 800
        case 1: return 400
        case 2: return 200
        default: return 70
        }
    }
    
    func estrelaTocada(_ estrela: Estrela) {
        print(estrela)
        Manager.shared.estrelaTocada = estrela
        if estrela.nivel == 0 {
            Manager.shared.showNewView = true
        } else {
            Manager.shared.showSubDescriptionView = true
        }
        
    }
    
    func estrelaCriada(_ estrela: Estrela) {
        if estrela.nivel > 0 {
            let novaEstrela = adicionarEstrelaNaTela(estrela)
            todasEstrelas.append(novaEstrela)
            ligaEstrela(novaEstrela)
        }
        let novaEstrela = adicionarEstrelaNaTela(estrela)
        todasEstrelas.append(novaEstrela)
        EstrelaManager.shared.addEstrela(novaEstrela)
    }
    
    func setConstelacoes() {
        for estrela in EstrelaManager.shared.todasEstrelas {
            print(adicionarEstrelaNaTela(estrela))
            ligaEstrela(estrela)
        }
    }
    

    func criarLinhaEntreEstrelas(_ estrela1: Estrela, _ estrela2: Estrela) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: estrela1.x, y: estrela1.y))
        path.addLine(to: CGPoint(x: estrela2.x, y: estrela2.y))
        
        let linha = SKShapeNode(path: path.cgPath)
        linha.strokeColor = SKColor.gray
        // Defina outras propriedades da linha, como espessura e transparência, conforme necessário
        linha.zPosition = -2
        
        self.addChild(linha)
    }
    
    func ligaEstrela(_ estrela: Estrela) {
        guard let origemID = estrela.estrelaOrigem else {
            return
        }
        if let origem = todasEstrelas.first(where: { $0.id == origemID }) {
            let path = UIBezierPath()
            path.move(to: estrela.position)
            path.addLine(to: origem.position)

            let lineNode = SKShapeNode(path: path.cgPath)
            lineNode.strokeColor = SKColor(white: 1.0, alpha: 0.5)
            lineNode.lineWidth = 2.0
            // Adicionar o nó de linha à cena
            self.addChild(lineNode)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for i in todasEstrelas {
            i.zRotation = cameraNode.zRotation
        }
    }
    
    
    

    
    // MARK: - Gestos
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        switch sender.state {
        case .changed:
            let translationInView = sender.translation(in: self.view)
            let angle = camera.zRotation
            let rotatedTranslation = CGPoint(x: cos(angle) * translationInView.x + sin(angle) * translationInView.y,
                                             y: -sin(angle) * translationInView.x + cos(angle) * translationInView.y)
            let translationInScene = CGPoint(x: rotatedTranslation.x * -camera.xScale, y: rotatedTranslation.y * camera.yScale)
            camera.position = CGPoint(x: camera.position.x + translationInScene.x, y: camera.position.y + translationInScene.y)
            sender.setTranslation(CGPoint.zero, in: self.view)

            panVelocity = sender.velocity(in: self.view)
            

//        case .ended, .cancelled:
//            applyPanInertia()

        default:
            break
        }
    }
    func applyPanInertia() {
        let decelerationRate: CGFloat = 0.75 // Ajuste conforme necessário
        let minSpeed: CGFloat = 2.0  // Ajuste conforme necessário

        let inertiaAction = SKAction.customAction(withDuration: 0.5) { [weak self] (_, elapsedTime) in
            guard let self = self, let camera = self.camera else { return }
            
            let angle = camera.zRotation
            let rotatedVelocity = CGPoint(x: cos(angle) * self.panVelocity.x + sin(angle) * self.panVelocity.y,
                                          y: -sin(angle) * self.panVelocity.x + cos(angle) * self.panVelocity.y)
            let velocityInScene = CGPoint(x: rotatedVelocity.x * -camera.xScale, y: rotatedVelocity.y * camera.yScale)
            camera.position = CGPoint(x: camera.position.x + velocityInScene.x * CGFloat(elapsedTime),
                                      y: camera.position.y + velocityInScene.y * CGFloat(elapsedTime))
            
            // Diminuir a velocidade
            self.panVelocity.x *= decelerationRate
            self.panVelocity.y *= decelerationRate
            
            // Parar a ação se a velocidade for muito baixa
            if self.panVelocity.length() < minSpeed {
                camera.removeAction(forKey: "panInertia")
            }
        }
        camera?.run(inertiaAction, withKey: "panInertia")
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
                Manager.shared.estrela = Estrela(reflexao: Reflexao(titulo: "", texto: ""), x: Double(locationInScene.x), y: Double(locationInScene.y))
                Manager.shared.showView = true

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
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}


