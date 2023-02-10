//
//  NewFeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/9/23.
//

import SwiftUI

struct NewFeedView: View {
  @State var textInput: String = ""
  var body: some View {
    NavigationStack {
      ZStack {
        GradientBackgroundFeed()
          .opacity(0.6)
        ScrollView {
          ForEach(0..<30) { _ in
            Rectangle()
              .fill(.ultraThinMaterial)
              .frame(maxWidth: .infinity, minHeight: 200)
              .cornerRadius(10)
              .padding()
            
          }
        }
        .searchable(text: $textInput, placement: .navigationBarDrawer)
      }
      .toolbarBackground(.hidden, for: .navigationBar)
    }
    .refreshable {
      // do stuff to refresh
    }
  }
}

struct NewFeedView_Previews: PreviewProvider {
  static var previews: some View {
    NewFeedView()
  }
}
