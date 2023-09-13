//
//  Onboarding3.swift
//  nova
//
//  Created by André Wozniack on 12/09/23.
//

import SwiftUI

struct Onboarding3: View {
    
    @Binding var showOnboarding : Bool
    
    var body: some View {
        Button {
            showOnboarding.toggle()
        } label: {
            Text("Ir para o App")
        }

    }
}

struct Onboarding3_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding3(showOnboarding: .constant(true))
    }
}
