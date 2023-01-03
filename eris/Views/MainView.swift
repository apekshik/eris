//
//  MainView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            // TODO: Come up with a new name for recent posts/activities (like how twitter has tweets).
            FeedView()
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Recent Activities")
                }
            
            MyProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile Page")
                }
            
            SearchPageView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        } // End of TabView
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
