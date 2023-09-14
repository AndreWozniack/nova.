import SwiftUI

struct InicialLoanding: View {
    
    @State private var currentTab = 0
    @State var isActive: Bool = false
    @State private var introOpacity = 1.0
    @State private var viewOpacity = 0.0
    
    @AppStorage("showOnboarding") private var showOnboarding = true
    
    
    var body: some View {
        VStack{
            ZStack{
                if !showOnboarding {
                    TabView(selection: $currentTab) {
                        Onboarding1(currentTab: $currentTab)
                            .tag(0)
                        Onboarding2(currentTab: $currentTab)
                            .tag(1)
                        Onboarding3(currentTab: $currentTab)
                            .tag(2)
                        OnBoarding4(showOnboarding: $showOnboarding).opacity(viewOpacity)
                            .tag(3)
                    }.tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                } else {
                    ContentView()
                        .environmentObject(NotificationManager.shared)
                        .environment(\.colorScheme, .light)
                        .opacity(viewOpacity)
                }
                Image("TelaInicial")
                    .resizable()
                    .scaledToFill()
                    .opacity(introOpacity)
                    .ignoresSafeArea()
            }
        }.onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                introOpacity = 0.0
                viewOpacity = 1.0
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
