import SwiftUI
import SpriteKit
import UserNotifications


struct ContentView: View {
    ///FEEDBACK TÁTIL E SONORO
    let soundManager = SoundManager.shared
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State var zoom: CGFloat = 1.0
    @GestureState var gestureZoom: CGFloat = 1.0
    @ObservedObject var manager = Manager.shared
    @EnvironmentObject var notificationManager: NotificationManager
    @State var showPopup = true
    
    @AppStorage("lastVisitDate") private var lastVisitDate = Date()
    @AppStorage("hasViewedWordOfTheDay") private var hasViewedWordOfTheDay: Bool = false
    
    init(){
        soundManager.playLoop(sound: .base1)
        soundManager.playLoop(sound: .base2)
        soundManager.playLoop(sound: .piano)
    }


    
    var body: some View {
    
        ZStack {
            ConstelacaoView()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                Text("Segure na tela para\ncriar um novo astro")
                    .foregroundColor(.gray)
                    .padding(.bottom, 25)
            }
            if showPopup {
                PopupView(closeAction: {
                    self.showPopup = false
                }, hasViewedWordOfTheDay: $hasViewedWordOfTheDay )
            }

            
            if manager.showCreatePrincipal {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                manager.showCreatePrincipal = false
                            }
                        }
                    CreatePrincipal(estrela: manager.estrela)
                        .onAppear{
                            soundManager.lowVolume(sound: .base1)
                            soundManager.lowVolume(sound: .base2)
                            soundManager.lowVolume(sound: .piano)
                        }
                        .onDisappear{
                            soundManager.riseVolume(sound: .base1)
                            soundManager.riseVolume(sound: .base2)
                            soundManager.riseVolume(sound: .piano)
                        }
                }
                
            }
            if manager.showPrincipalDescription {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                manager.showPrincipalDescription = false
                            }
                        }
                    CardsView()
                        .onAppear{
                            soundManager.lowVolume(sound: .base1)
                            soundManager.lowVolume(sound: .base2)
                            soundManager.lowVolume(sound: .piano)
                        }
                        .onDisappear{
                            soundManager.riseVolume(sound: .base1)
                            soundManager.riseVolume(sound: .base2)
                            soundManager.riseVolume(sound: .piano)
                        }
                }
                
            }
            if manager.showSubCreate{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            manager.showSubCreate = false
                        }
                    }
                SubCreateView()
                    .onAppear{
                        soundManager.lowVolume(sound: .base1)
                        soundManager.lowVolume(sound: .base2)
                        soundManager.lowVolume(sound: .piano)
                    }
                    .onDisappear{
                        soundManager.riseVolume(sound: .base1)
                        soundManager.riseVolume(sound: .base2)
                        soundManager.riseVolume(sound: .piano)
                    }
            }
            if manager.showSubDescription {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                manager.showSubDescription = false
                            }
                        }
                    CardsView()
                        .onAppear{
                            soundManager.lowVolume(sound: .base1)
                            soundManager.lowVolume(sound: .base2)
                            soundManager.lowVolume(sound: .piano)
                        }
                        .onDisappear{
                            soundManager.riseVolume(sound: .base1)
                            soundManager.riseVolume(sound: .base2)
                            soundManager.riseVolume(sound: .piano)
                        }
                }
            }
        }
        .onAppear {
            //play na musica de fundo com 3 camadas
            
           
            print(EstrelaManager.shared.palavraDoDia as Any)
            checkForDailyPopup()
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleDailyNotifications()
            
            if hasViewedWordOfTheDay {
                NotificationManager.shared.cancelAllNotifications()
            }
            
        }
        .onReceive(notificationManager.$notificationResponse) { response in
            if let response = response {
                print("Palavra do dia: \(manager.palavraDoDia)")
                print("Notificação recebida com identificador: \(response.notification.request.identifier) \(response.description)")
            }
        }
    }
    
    func checkForDailyPopup() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastVisitDay = calendar.startOfDay(for: lastVisitDate)
        
        if today != lastVisitDay {
            self.showPopup = true
            self.lastVisitDate = Date()
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

struct PopupView: View {
    
    var closeAction: () -> Void
    
    @Binding var hasViewedWordOfTheDay: Bool
    
    var body: some View {
        VStack {
            Text("A palavra do dia é:")
                .padding()
            Text(Manager.shared.palavraDoDia)
                .font(.title2)
            
            HStack{
                Button(action: {
                    closeAction()
                    hasViewedWordOfTheDay = true
                }) {
                    Text("Fechar")
                }
                .padding()
                Button {
                    closeAction()
                    hasViewedWordOfTheDay = true
                    Manager.shared.showCreatePrincipal.toggle()
                } label: {
                    Text("Criar Astro")
                }

            }
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()

    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}


struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(NotificationManager.shared)
    }
}


