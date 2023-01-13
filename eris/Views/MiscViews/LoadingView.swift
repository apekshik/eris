//
//  LoadingView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct LoadingView: View {
  @Binding var show: Bool
  var body: some View {
    ZStack {
      if show {
        Group {
          // Just a blur background.
          Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
          
          // The square loading view.
          ProgressView()
            .padding()
            .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
      }
    } // End of VStack
    .animation(.easeInOut(duration: 0.25), value: show)
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingView(show: Binding.constant(true))
  }
}
