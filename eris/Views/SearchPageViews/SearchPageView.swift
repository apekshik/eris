//
//  SearchPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/29/22.
//

import SwiftUI

struct SearchPageView: View {
  @State private var keyword = ""
  @State var userQueries: [User] = []
  @State var usersIFollow: [User] = exampleUsers
  @State var usersThatFollowMe: [User] = exampleUsers
  @State var showFollowers: Bool = true
  var body: some View {
    // creating a binding so that fetchUser(containing) is called whenever the keyword changes.
    // TODO: Read more on this. It's kinda confusing how this works right now.
    let keywordBinding = Binding<String> (
      get: {
        keyword
      },
      set: {
        keyword = $0
        fetchUsers(containing: keyword)
      })
    
    
    // MARK: Navigation Stack for search Page
    NavigationStack {
      ZStack {
        BackgroundView()
        if userQueries.count > 0 {
          searchBarResults
        }
        
        if usersIFollow.count > 0 {
          searchPageBody
        } else {
          EmptySearchView()
        }
        
      }
      .navigationTitle("Search People")
    } // End of NavigationStack for Search Page.
    .refreshable {
      fetchUsersIFollow()
    }
    .searchable(text: keywordBinding)
    .task {
      fetchUsersIFollow()
    }
  }
  
  // Search Bar results List.
  var searchBarResults: some View {
    VStack {
      LazyVStack(alignment: .leading) {
        ForEach(userQueries, id: \.id) { user in
          NavigationLink {
            LUserProfileView(user: user, usersIFollow: $usersIFollow)
          } label: {
            SearchUserCardView(user: user)
              .padding([.horizontal], 12)
              .padding([.vertical], 8)
          }
        }
      }
      .background(.thickMaterial)
      .cornerRadius(10)
      .padding()
      
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.ultraThinMaterial)
    .zIndex(userQueries.count > 0 ? 1 : 0)
  }
  
  // Body of the Search Page
  var searchPageBody: some View {
    ScrollView(.vertical, showsIndicators: false){
//      Picker("Connections", selection: $showFollowers) {
//        Text("Following")
//          .tag(true)
//        Text("Followers")
//          .tag(false)
//      }
//      .pickerStyle(SegmentedPickerStyle())
//      .padding()
//      .shadow(radius: 4)
//
      Text("Following".uppercased())
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal], 20)
        .opacity(0.6)
      
      followingBody
      
      DeveloperMastFooter()
    }
  }
  
  var followingBody: some View {
    LazyVStack(spacing: 12) {
      ForEach(usersIFollow, id: \.id) { user in
        NavigationLink {
          LUserProfileView(user: user, usersIFollow: $usersIFollow)
        } label: {
          UserCardView(user: user)
        }
      }
    }
    .padding()
    .onAppear {
      fetchUsersIFollow()
    }
    .cornerRadius(10)
    .overlay {
      CardGradient()
    }
    .padding()
  }
  
  // Fetches all users I follow and stores it in the usersIFollow var.
  private func fetchUsersIFollow() {
    // fetch the "following" subcollection within the current user's document.
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
    let db = FirebaseManager.shared.firestore
    db.collection("Users").document(userID).collection("Following").getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      usersIFollow = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: User.self)
      }
    }
  }
  
  private func fetchUsersThatFollowMe() {
    // fetch the "followers" subcollection within the current user's document.
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
    let db = FirebaseManager.shared.firestore
    db.collection("Users").document(userID).collection("Followers").getDocuments { QuerySnapshot, error in
      guard let documents = QuerySnapshot?.documents, error == nil else { return }
      
      usersThatFollowMe = documents.compactMap({ QueryDocumentSnapshot in
        try? QueryDocumentSnapshot.data(as: User.self)
      })
    }
  }
  
  // fetch users for the search functionality. Fetches those users that have the keyword that you type in the search bar in their userName and Full Name.
  private func fetchUsers(containing keyword: String) {
    let db = FirebaseManager.shared.firestore
    db.collection("Users").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
      userQueries = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: User.self)
      }
      
    }
  } // End of method fetchUsers()
}

struct SearchPageView_Previews: PreviewProvider {
  static var previews: some View {
    SearchPageView(usersIFollow: exampleUsers)
  }
}
