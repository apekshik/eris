//
//  BackgroundView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/18/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct BackgroundView: View {
  @State var gradientColors = [Color.purple, Color.black, Color(hex: "ff004c")]
  @State var startPoint = UnitPoint(x: 0, y: 0)
  @State var endPoint = UnitPoint(x: 0, y: 2)
  
  var body: some View {
    background
  }
  
  var background: some View {
    LinearGradient(gradient: Gradient(colors: self.gradientColors), startPoint: self.startPoint, endPoint: self.endPoint)
      .ignoresSafeArea()
      .blur(radius: 50)
      .opacity(0.4)
      .onAppear {
        withAnimation (.easeInOut(duration: 10)
          .repeatForever(autoreverses: true).speed(0.25)){
            self.startPoint = UnitPoint(x: 1, y: -1)
            self.endPoint = UnitPoint(x: 0, y: 1)
          }
      }
  }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
