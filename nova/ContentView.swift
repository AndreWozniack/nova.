import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @State var zoom: CGFloat = 1.0
    @GestureState var gestureZoom: CGFloat = 1.0
    @ObservedObject var manager = Manager.shared
    
    var body: some View {
    
        ZStack {
            ConstelacaoView()
                .edgesIgnoringSafeArea(.all)
            
            if manager.showView {
                // Fundo semi-transparente
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            manager.showView = false
                        }
                    }
                TemaView(estrela: manager.estrela)
                
            }
            if manager.showNewView {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            manager.showNewView = false
                        }
                    }
                DescriptionView(estrela: manager.estrelaTocada)
                
            }
        }
         
    }
}


struct ConstelacaoView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.presentScene(ConstelacaoScene(size: skView.bounds.size))
        viewController.view = skView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Atualizações, se necessárias.
    }
}


struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
