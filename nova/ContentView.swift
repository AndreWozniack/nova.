import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @State var zoom: CGFloat = 1.0
    @GestureState var gestureZoom: CGFloat = 1.0
    let skView = SKView(frame: UIScreen.main.bounds)
    
    var body: some View {
        ZStack{
            SpriteView(scene: ConstelacaoScene(size: skView.bounds.size)).ignoresSafeArea()
            TemaView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
