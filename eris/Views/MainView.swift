//
//  MainView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct MainView: View {
  @State var usersIFollow: [User] = []
  var body: some View {
    TabView {
      // TODO: Come up with a new name for recent posts/activities (like how twitter has tweets).
      FeedView()
        .tabItem {
          Image(systemName: "circle.hexagongrid.fill")
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
    .task {
      await fetchUsersIFollow()
    }
  } // end of view body
  
  
  private func fetchUsersIFollow() async {
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
    let followingRef = FirebaseManager.shared.firestore.collection("Users").document(userID).collection("Following")
    followingRef.getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
      usersIFollow = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: User.self)
      }
    }
  } // End of method fetchUsers()
}




struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
