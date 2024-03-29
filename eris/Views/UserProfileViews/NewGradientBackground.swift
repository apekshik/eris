//
//  NewGradientBackground.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/5/23.
//

import SwiftUI

struct NewGradientBackground: View {
  @State var start = UnitPoint(x: 0, y: -2)
  @State var end = UnitPoint(x: 4, y: 0)
  
  let colors = [Color(#colorLiteral(red: 0.9843137255, green: 0.9176470588, blue: 0.6470588235, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9108665586, blue: 0.653829813, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.7512738109, blue: 0.6763105392, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.2626227736, blue: 0.2668531835, alpha: 1)), Color(#colorLiteral(red: 0.001610695035, green: 0.08892402798, blue: 0.2752042115, alpha: 1))]
  let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
  
  var body: some View {
    background
      .blur(radius: 10)
  }
  
  var background: some View {
    LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end).edgesIgnoringSafeArea(.all)
      .animation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true).speed(0.5))
      .onReceive(timer, perform: { _ in
        self.start = UnitPoint(x: 4, y: 0)
        self.end = UnitPoint(x: 0, y: 2)
        self.start = UnitPoint(x: -4, y: 20)
        self.start = UnitPoint(x: 4, y: 0)
      })
  }
}

struct NewGradientBackground_Previews: PreviewProvider {
  static var previews: some View {
    NewGradientBackground()
  }
}
