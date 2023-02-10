//
//  NewHomeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/10/23.
//

import SwiftUI

struct NewHomeView: View {
  @State var selectedTab: Int = 0
  var body: some View {
    TabView(selection: $selectedTab) {
      
      NewFeedView()
        .tag(0)
        .tabItem {
          Image(systemName: "camera")
        }
        .toolbarBackground(.hidden, for: .navigationBar)
//        .toolbarBackground(.hidden, for: .tabBar)

      
      MyProfileView(boujees: exampleLivePosts)
        .tag(1)
        .tabItem {
          Image(systemName: "magnifyingglass")
        }
//        .toolbarBackground(.hidden, for: .tabBar)
      AboutSheetView()
        .tag(2)
        .tabItem {
          Image(systemName: "tray")
        }
//        .toolbarBackground(.hidden, for: .tabBar)
    }
    
//    .tabViewStyle(.page(indexDisplayMode: .never))
//    .edgesIgnoringSafeArea(.bottom)
  }
}

struct NewHomeView_Previews: PreviewProvider {
  static var previews: some View {
    NewHomeView()
  }
}
