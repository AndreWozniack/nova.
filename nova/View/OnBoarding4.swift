//
//  OnBoarding4.swift
//  nova
//
//  Created by Afonso Rekbaim on 14/09/23.
//

import SwiftUI

struct OnBoarding4: View {
    @Binding var showOnboarding : Bool
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 10) {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0))
                
                VStack(alignment: .center, spacing: 32) {
                    
                    ZStack{
                        Image("constelacao2")
                            .frame(height: 195)
                    }
                    
                    VStack(alignment: .center, spacing: 16) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "hand.draw")
                              .font(.system(size: 48)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                
                                HStack{
                                    Text("Navegue pelo seu mapa para ver e apreciar suas constelações.")
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
                            Image(systemName: "hand.tap")
                              .font(.system(size: 48)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack{
                                    Text("Clique no astro que quiser para ler ou editar a sua reflexão")
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
                            Image(systemName: "bubbles.and.sparkles.fill")
                              .font(.system(size: 48)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 55, alignment: .top)
                            VStack(alignment: .center, spacing: 6) {
                                HStack{
                                    Text("Revisite suas reflexões antes antes que elas virem poeira espacial.")
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
                    showOnboarding.toggle()
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

struct OnBoarding4_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding4(showOnboarding: .constant(true))
    }
}
