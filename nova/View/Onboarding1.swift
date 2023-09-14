//
//  Onboarding1.swift
//  nova
//
//  Created by André Wozniack on 12/09/23.
//

import SwiftUI

struct Onboarding1: View {
    @Binding var currentTab : Int
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 10) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0))
                
                VStack(alignment: .center, spacing: 32) {
                    Image("logotipo")
                        .scaleEffect(0.5)
                    
                        .frame(height: 195)
                    VStack(alignment: .center, spacing: 16) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 48)
                                    .weight(.light)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack(){
                                    Text("Título 1")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                                
                                HStack{
                                    Text("Crie seu próprio universo cheio de constelaçoes blablablablaa")
                                        .font(.system(size: 13))
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                            }
                            .padding(10)
                            .frame(width: 212, height: 90, alignment: .center)
                            
                        }
                        .padding(0)
                        
                        HStack(alignment: .center, spacing: 10) {
                            Image("icone-planeta")
                                .font(.system(size: 48)
                                    .weight(.light)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack(){
                                    Text("Título 2")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                                
                                HStack{
                                    Text("Assim como as estrelas, nossos pensamentos vem e vão ballablablbalbalabla")
                                        .font(.system(size: 13))
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                        .lineLimit(3)
                                    
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                            }
                            .padding(10)
                            .frame(width: 212, height: 90, alignment: .center)
                            
                        }
                        .padding(0)
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "moon.stars.fill")
                                .font(.system(size: 48)
                                    .weight(.light)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack(){
                                    Text("Título 3")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                                
                                HStack{
                                    Text("Favorite as constelaçoes que voce deseja guardar")
                                        .font(.system(size: 13))
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                            }
                            .padding(10)
                            .frame(width: 212, height: 90, alignment: .center)
                            
                        }
                        .padding(0)
                    }
                    .padding(0)
                }
                .padding(0)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0))
                
                Button{
                    currentTab = 1
                } label:{
                    HStack(alignment: .top, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 8) {
                            Text("Continuar")
                                .font(Font.custom("Kodchasan-Bold", size: 15))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .bold()
                            
                            Image(systemName: "sparkle")
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                        .cornerRadius(12)
                    }
                    .padding(0)
//                    .padding(.bottom, 20)
                    .frame(width: 316, alignment: .topLeading)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 16)
            .padding(.bottom, 28)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }.background{
            ZStack{
                Image("background")
            }.background(.black)
        }
    }
}

struct Onboarding1_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding1(currentTab: .constant(0))
    }
}
