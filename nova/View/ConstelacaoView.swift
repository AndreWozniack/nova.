import Foundation
import SwiftUI
import SpriteKit

struct ConstelacaoView: UIViewControllerRepresentable, EstrelaDelegate {
    func estrelaTocada(_ estrela: Estrela) {
//        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.presentScene(ConstelacaoScene(size: skView.bounds.size))
        viewController.view = skView
        return viewController
    }
    
    func abrirComponenteSwiftUI() {
        // Código para abrir o novo componente
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Atualizações, se necessárias.
    }
}
