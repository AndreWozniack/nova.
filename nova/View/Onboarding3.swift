//
//  Onboarding3.swift
//  nova
//
//  Created by André Wozniack on 12/09/23.
//

import SwiftUI

struct Onboarding3: View {
    @Binding var currentTab : Int
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 10) {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0))
                
                VStack(alignment: .center, spacing: 32) {
                    
                    ZStack{
                        Image("constelacao")
                            .frame(height: 195)
                    }
                    
                    VStack(alignment: .center, spacing: 16) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "sparkle")
                              .font(.system(size: 48)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                
                                HStack{
                                    Text("Pressione um lugar vazio no espaço para criar uma nova constelação.")
                                      .font(.system(size: 14))
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
                            Image(systemName: "sparkles")
                              .font(.system(size: 48)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack{
                                    Text("Adicione outros astros para formar suas constelações e anotar mais reflexões.")
                                      .font(.system(size: 14))
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
                            Image(systemName: "timer")
                              .font(.system(size: 48)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack{
                                    Text("Assim como estrelas no universo, seus pensamentos tem um tempo de vida.")
                                      .font(.system(size: 14))
                                      .foregroundColor(.white)
                                      .lineLimit(3)
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                            }
                            .padding(10)
                            .frame(width: 212, height: 76, alignment: .center)
                            
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
                    currentTab = 3
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

struct Onboarding3_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding3(currentTab: .constant(0))
    }
}
