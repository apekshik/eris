//
//  Test2View.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/10/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct ScrollViewTest: View {
  @Namespace var topID
  @Namespace var bottomID

  var body: some View {
      ScrollViewReader { proxy in
          ScrollView {
              Button("Scroll to Bottom") {
                  withAnimation {
                      proxy.scrollTo(bottomID)
                  }
              }
              .id(topID)

              VStack(spacing: 0) {
                  ForEach(0..<100) { i in
                      color(fraction: Double(i) / 100)
                          .frame(height: 32)
                  }
              }

              Button("Top") {
                  withAnimation {
                      proxy.scrollTo(topID)
                  }
              }
              .id(bottomID)
          }
      }
  }

  func color(fraction: Double) -> Color {
      Color(red: fraction, green: 1 - fraction, blue: 0.5)
  }
}

struct ScrollViewTest_Previews: PreviewProvider {
    static var previews: some View {
        Test2View()
    }
}
