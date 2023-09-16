import SwiftUI
import SpriteKit
import UserNotifications


struct ContentView: View {

    @State var check = true

    let soundManager = SoundManager.shared
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State var zoom: CGFloat = 1.0
    @GestureState var gestureZoom: CGFloat = 1.0
    @ObservedObject var manager = Manager.shared
    @EnvironmentObject var notificationManager: NotificationManager
    
    @AppStorage("lastVisitDate") var lastVisitDate: Date = Date().addingTimeInterval(-86400)
    @State private var showPopup: Bool = true
    
    init(){
        soundManager.printPan(sound: .base1)
        soundManager.printPan(sound: .base2)
        soundManager.printPan(sound: .piano)
        
        soundManager.playLoop(sound: .base1)
        soundManager.playLoop(sound: .base2)
        soundManager.playLoop(sound: .piano)
        
        soundManager.recoverAlt(sound: .base1)
        soundManager.recoverAlt(sound: .base2)
        soundManager.recoverAlt(sound: .piano)
        
        checkFirstVisitToday()
    }


    
    var body: some View {
    
        ZStack {
            ConstelacaoView()
                .onTapGesture {
                    soundManager.printPan(sound: .base1)
                    soundManager.printPan(sound: .base2)
                    soundManager.printPan(sound: .piano)
                }
            
            VStack{
                HStack{
                    Spacer()
                    Button{
                        check ? soundManager.stop(sound: .base1) : soundManager.playLoop(sound: .base1)
                        check ? soundManager.stop(sound: .base2) : soundManager.playLoop(sound: .base2)
                        check ? soundManager.stop(sound: .piano) : soundManager.playLoop(sound: .piano)
                        
                        check.toggle()
                    }label: {
                        Image(systemName: check ? "speaker.wave.2" : "speaker.slash")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                    }
                }.padding(.top, 70)
                    .padding(.trailing, 15)
                Spacer()
                Text("Segure na tela para\ncriar um novo astro")
                    .foregroundColor(.gray)
                    .padding(.bottom, 25)
            }
            if showPopup {
                PopupView(closeAction: {
                    showPopup.toggle()
                })
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
            
            checkFirstVisitToday()

            print(EstrelaManager.shared.palavraDoDia!)
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleDailyNotifications()
            NotificationManager.shared.scheduleNotification(timeInterval: 60 * 60 * 4, repeats: true)
            
//            if hasViewedWordOfTheDay {
//                NotificationManager.shared.cancelAllNotifications()
//            }
            
        }
        .onReceive(notificationManager.$notificationResponse) { response in
            if let response = response {
                print("Palavra do dia: \(manager.palavraDoDia)")
                print("Notificação recebida com identificador: \(response.notification.request.identifier) \(response.description)")
            }
        }
    }
    
    func checkFirstVisitToday() {
        let calendar = Calendar.current

        // Se a última data de visita não for hoje, mostramos o popup
        if !calendar.isDateInToday(lastVisitDate) {
            showPopup = true
        }

        // Atualizamos a última data de visita para agora
        lastVisitDate = Date()
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
    var estrela = Estrela()
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                closeAction()
                            }
                        }
            VStack{
                Image(estrela.getIcon())
                    .frame(width: 45)
                    .scaledToFit()
                VStack {
                    VStack(spacing: 6){
                        Text("O tema do dia é:")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        Text(Manager.shared.palavraDoDia)
                            .font(.custom("Kodchasan-Regular", size: 26))
                            .bold()
                        
                        Text(estrela.tipo!.rawValue)
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(.gray)
                        Text("\(estrela.getDuracao()) de vida")
                            .font(.system(size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }.padding(.top, 20)
                    Spacer()
                    HStack{
                        Button(action: {
                            closeAction()
                        }) {
                            Text("Fechar")
                                .foregroundColor(.white)
                                .font(.custom("Kodchasan-Regular", size: 15))
                                .bold()
                        }
                        .frame(width: 121, height: 49)
                        .background(.black)
                        .cornerRadius(12)
                        
                        Button {
                            closeAction()
                            Manager.shared.estrela = estrela
                            Manager.shared.showCreatePrincipal.toggle()
                            Manager.shared.useWord.toggle()
                        } label: {
                            Text("Criar")
                                .foregroundColor(.white)
                                .font(.custom("Kodchasan-Regular", size: 15))
                                .bold()
                        }
                        .frame(width: 121, height: 49)
                        .background(.black)
                        .cornerRadius(12)
                        
                    }.padding(.bottom)
                }
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
        }
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


