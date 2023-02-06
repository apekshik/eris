//
//  NavTest.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/5/23.
//

import SwiftUI

struct NavTest: View {
  @State private var selectedTab = 0
  
  let numTabs = 2
  let minDragTranslationForSwipe: CGFloat = 30
  
  var body: some View {
    TabView(selection: $selectedTab) {
      GeoReaderTest()
        .toolbar(.hidden, for: .tabBar)
        .tabItem {
          Image(systemName: "mail")
        }
        .tag(0)
        .highPriorityGesture(DragGesture().onEnded({
          self.handleSwipe(translation: $0.translation.width)
        }))
      
      AboutSheetView()
        .tabItem {
          Image(systemName: "tray")
        }
        .tag(1)
        .highPriorityGesture(DragGesture().onEnded({
          self.handleSwipe(translation: $0.translation.width)
        }))
    }
    
  }
  
  private func handleSwipe(translation: CGFloat) {
    if translation > minDragTranslationForSwipe && selectedTab > 0 {
      selectedTab -= 1
    } else  if translation < -minDragTranslationForSwipe && selectedTab < numTabs-1 {
      selectedTab += 1
    }
  }
}

struct NavTest_Previews: PreviewProvider {
  static var previews: some View {
    NavTest()
  }
}
