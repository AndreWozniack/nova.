import SwiftUI
import SpriteKit
import UserNotifications


struct ContentView: View {
    ///FEEDBACK TÁTIL E SONORO
    let soundManager = SoundManager()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State var zoom: CGFloat = 1.0
    @GestureState var gestureZoom: CGFloat = 1.0
    @ObservedObject var manager = Manager.shared
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
    
        ZStack {
            ConstelacaoView()
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        soundManager.riseVolume(sound: .base1)
                        soundManager.riseVolume(sound: .base2)
                        soundManager.riseVolume(sound: .piano)
                        
                        
                        if value.translation.width < 0 {
//                            soundManager.leftAlt(sound: .base1)
                            soundManager.leftAlt(sound: .base2)
                            soundManager.leftAlt(sound: .piano)
                        }

                        if value.translation.width > 0 {
//                            soundManager.rightAlt(sound: .base1)
                            soundManager.rightAlt(sound: .base2)
                            soundManager.rightAlt(sound: .piano)
                        }
                    })
                    .onEnded({value in
                            soundManager.recoverAlt(sound: .base1)
                            soundManager.recoverAlt(sound: .base2)
                            soundManager.recoverAlt(sound: .piano)
                    })
                )
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                Text("Segure na tela para\ncriar um novo astro")
                    .foregroundColor(.gray)
                    .padding(.bottom, 25)
                
//                HStack{
//                    Button {
//                        print(EstrelaManager.shared.todasEstrelas)
//                        print(EstrelaManager.shared.estrelasExpiradas)
//                    } label: {
//                        Text("Lista de estrelas")
//                            .font(.custom("Kodchasan", size: 15))
//                            .padding(10)
//                            .background(.white)
//                            .foregroundColor(.black)
//                            .cornerRadius(12)
//                    }
//                    Button {
//                        EstrelaManager.shared.clearSky()
//                        manager.estrela = Estrela()
//
//                    } label: {
//                        Text("Limpar Estrelas")
//                            .font(.custom("Kodchasan", size: 15))
//                            .padding(10)
//                            .background(.white)
//                            .font(.system(size: 15))
//                            .foregroundColor(.black)
//                            .cornerRadius(12)
//                    }
//                }
            }

            
            if manager.showView {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            soundManager.riseVolume(sound: .base1)
                            soundManager.riseVolume(sound: .base2)
                            soundManager.riseVolume(sound: .piano)
                            
                            withAnimation {
                                manager.showView = false
                            }
                        }
                    TemaView(estrela: manager.estrela)
                        .onAppear{
                            soundManager.lowVolume(sound: .base1)
                            soundManager.lowVolume(sound: .base2)
                            soundManager.lowVolume(sound: .piano)
                        }
                }
                
            }
            if manager.showNewView {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        soundManager.riseVolume(sound: .base1)
                        soundManager.riseVolume(sound: .base2)
                        soundManager.riseVolume(sound: .piano)
                        
                        withAnimation {
                            manager.showNewView = false
                        }
                    }
                DescriptionView(estrela: manager.estrelaTocada)
                    .onAppear{
                        soundManager.lowVolume(sound: .base1)
                        soundManager.lowVolume(sound: .base2)
                        soundManager.lowVolume(sound: .piano)
                    }
                
            }
            if manager.showSubView{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        soundManager.riseVolume(sound: .base1)
                        soundManager.riseVolume(sound: .base2)
                        soundManager.riseVolume(sound: .piano)
                        
                        withAnimation {
                            manager.showSubView = false
                        }
                    }
                SubView()
                    .onAppear{
                        soundManager.lowVolume(sound: .base1)
                        soundManager.lowVolume(sound: .base2)
                        soundManager.lowVolume(sound: .piano)
                    }
            }
            if manager.showSubDescriptionView {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        soundManager.riseVolume(sound: .base1)
                        soundManager.riseVolume(sound: .base2)
                        soundManager.riseVolume(sound: .piano)
                        
                        withAnimation {
                            manager.showSubDescriptionView = false
                        }
                    }
                SubDescriptionView(estrela: manager.estrelaTocada)
                    .onAppear{
                        soundManager.lowVolume(sound: .base1)
                        soundManager.lowVolume(sound: .base2)
                        soundManager.lowVolume(sound: .piano)
                    }
            }
        }
        .onAppear {
            //play na musica de fundo com 3 camadas
            soundManager.playLoop(sound: .base1)
            soundManager.playLoop(sound: .base2)
            soundManager.playLoop(sound: .piano)
           
            print(EstrelaManager.shared.palavraDoDia as Any)
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleDailyNotification(at: 13, minute: 00)
        }
        .onReceive(notificationManager.$notificationResponse) { response in
            if let response = response {
                print("Palavra do dia: \(manager.palavraDoDia)")
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
