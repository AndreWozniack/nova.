import SwiftUI

struct InicialLoanding: View {
    
    @State private var currentTab = 0
    @State var isActive: Bool = false
    @State private var introOpacity = 2.0
    @State private var viewOpacity = 0.0
    
    @AppStorage("showOnboarding") private var showOnboarding = true
//    @State var showOnboarding = true
    
    
    var body: some View {
        VStack{
            ZStack{
                if showOnboarding {
                    TabView(selection: $currentTab) {
                        Onboarding1(currentTab: $currentTab)
                            .tag(0)
                            .padding(25)
                        Onboarding2(currentTab: $currentTab)
                            .tag(1)
                            .padding(25)
                        Onboarding3(currentTab: $currentTab)
                            .tag(2)
                            .padding(25)
                        OnBoarding4(showOnboarding: $showOnboarding).opacity(viewOpacity)
                            .tag(3)
                            .padding(25)
                    }.tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                        .opacity(viewOpacity)
                } else {
                    ContentView()
                        .environmentObject(NotificationManager.shared)
                        .environment(\.colorScheme, .light)
                        .opacity(viewOpacity)
                }
                ZStack{
                    Image("background")
                        .resizable()
                        .opacity(introOpacity)
                    Image("logotipo")
                        .resizable()
                        .scaledToFit()
                        .opacity(introOpacity)
                }.background(.black)
                    .opacity(introOpacity)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Atraso de 2 segundos
                withAnimation(.easeInOut(duration: 2.0)) {
                    introOpacity = 0.0
                    viewOpacity = 1.0
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct InicialLoanding_Previews: PreviewProvider {
    static var previews: some View {
        InicialLoanding()
    }
}
