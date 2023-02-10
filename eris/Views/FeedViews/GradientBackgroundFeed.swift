//
//  GradientBackgroundFeed.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/10/23.
//

import SwiftUI

struct GradientBackgroundFeed: View {
  @State var start = UnitPoint(x: 0, y: -2)
  @State var end = UnitPoint(x: 4, y: 0)
  
  let colors = [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))]
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

struct GradientBackgroundFeed_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackgroundFeed()
    }
}
