import SwiftUI

struct TemaView: View {
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                VStack(alignment: .center, spacing: 4) {
                    Text("Amizade")
                        .font(
                            Font.custom("Kodchasan", size: 18)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    HStack(alignment: .center, spacing: 4) {
                        Text("Planeta gasoso")
                            .font(
                                Font.custom("SF Pro", size: 9)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                    }
                    .padding(0)
                    Text("20 dias de vida restante")
                        .font(Font.custom("Inter", size: 9))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 124, alignment: .top)
                }.padding(10)
                Button {
                    
                } label: {
                    Text(.init(systemName: "plus.circle.fill"))
                        .font(.system(size: 32))
                        .foregroundColor(.black)
                }
                .padding(.bottom ,24)
            }
            
            .frame(width: 300, height: 194, alignment: .top)
            .background(.white)
            .cornerRadius(16)
            VStack(alignment: .center, spacing: 10) {
                
            }
            .padding(0)
            .frame(width: 85, height: 85, alignment: .center)
            .background(.black)
            .cornerRadius(100)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .inset(by: 1)
                    .stroke(.white, lineWidth: 2)
            )
        }
        
    }
}

struct TemaView_Previews: PreviewProvider {
    static var previews: some View {
        TemaView()
    }
}
