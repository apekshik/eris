//
//  CardGradient.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/21/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct CardGradient: View {
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(
        LinearGradient(
          gradient: Gradient(colors: [.white.opacity(0.8), .white.opacity(0.2)]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ),
        lineWidth: 0.4
      )
  }
}

struct CardGradient_Previews: PreviewProvider {
    static var previews: some View {
        CardGradient()
    }
}
