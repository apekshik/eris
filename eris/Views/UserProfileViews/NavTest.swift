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
            Image(systemName: "tray")
        }
        .tag(0)
      
      AboutSheetView()
        .tabItem {
            Image(systemName: "camera")
        }
        .tag(1)
      AboutSheetView()
        .tabItem {
            Image(systemName: "camera")
        }
        .tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .ignoresSafeArea()
    
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
