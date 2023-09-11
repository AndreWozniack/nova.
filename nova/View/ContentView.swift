import SwiftUI
import SpriteKit
import UserNotifications


struct ContentView: View {
    
    @State var zoom: CGFloat = 1.0
    @GestureState var gestureZoom: CGFloat = 1.0
    @ObservedObject var manager = Manager.shared
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
    
        ZStack {
            ConstelacaoView()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Button {
                        print(EstrelaManager.shared.todasEstrelas)
                    } label: {
                        Text("Lista de estrelas")
                            .font(.custom("Kodchasan-Bold", size: 15))
                            .padding(10)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    Button {
                        EstrelaManager.shared.clearSky()
                        manager.estrela = Estrela()
                        
                    } label: {
                        Text("Limpar Estrelas")
                            .padding(10)
                            .background(.white)
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }
            }

            
            if manager.showView {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                manager.showView = false
                            }
                        }
                    TemaView(estrela: manager.estrela)
                }
                
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
            if manager.showSubView{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            manager.showSubView = false
                        }
                    }
                SubView()
            }
            if manager.showSubDescriptionView {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            manager.showSubDescriptionView = false
                        }
                    }
                SubDescriptionView(estrela: manager.estrelaTocada)
            }
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleNotification(title: "Um novo astro surgiu!", body: "Parece que há um novo astro em seu céu", timeInterval: 120, repeats: false)
        }
        .onReceive(notificationManager.$notificationResponse) { response in
            if let response = response {

                print("Notificação recebida com identificador: \(response.notification.request.identifier) \(response.description)")
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
        ContentView().environmentObject(NotificationManager.shared)
    }
}
