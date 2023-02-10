//
//  NewFeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/9/23.
//

import SwiftUI

struct NewFeedView: View {
  var body: some View {
    NavigationStack {
      ZStack {
        GradientBackgroundFeed()
          .opacity(0.8)
        Text("Hello World")
      }
    }
  }
}

struct NewFeedView_Previews: PreviewProvider {
  static var previews: some View {
    NewFeedView()
  }
}
