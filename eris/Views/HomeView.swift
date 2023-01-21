//
//  HomeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI
import FirebaseMessaging

struct HomeView: View {
  @AppStorage("log_status") var logStatus: Bool = false
  @AppStorage("showOnboardingView") var showOnboardingView: Bool = true
  @State var usersIFollow: [User] = []
  @State var fcmTokenData: [String : Any] = [:]
  @StateObject var myData: MyData = MyData()
  
  var body: some View {
    // Redirecting User based on LogStatus
    VStack {
      if logStatus {
        mainView
      }
      else {
        LoginView()
      }
    }
    .onAppear {
      Task { await refreshFCMToken() }
    }
    .environmentObject(myData)
  }
  
  var mainView: some View {
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
    .tint(.white)
    .task {
      usersIFollow = await fetchUsersIFollow()
      myData.usersIFollow = usersIFollow
    }
    .fullScreenCover(isPresented: $showOnboardingView, content: {
      OnboardingView(showOnboardingView: $showOnboardingView)
    })
  }
  
  private func refreshFCMToken() async {
    do {
      // If logStatus is true, user profile data does exist. So fetch it and store it in myData.
      // TODO: Then check if current FCM token is fresh. If not, then update it.
      if logStatus == true {
        myData.myUserProfile = try await fetchCurrentUser()
        
        let token = try await Messaging.messaging().token()
        
        let tokensRef = FirebaseManager.shared.firestore.collection("FCMTokens")
        let newToken = FCMToken(userID: myData.myUserProfile!.firestoreID,
                                token: token,
                                createdAt: Date())
        
        let _ = try tokensRef.document(myData.myUserProfile!.firestoreID).setData(from: newToken)
        myData.fcmToken = newToken
      }
    } catch {
      
    }
  }
  
  // MARK: Fetch Current User Data
  func fetchCurrentUser() async throws -> User? {
    // Fetch the current logged in user ID if user is logged in.
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return nil }
    // Fetch user data from Firestore using the userID.
    let user = try await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self)
    
    return user
  }
  
  private func fetchUsersIFollow() async -> [User] {
    var usersIFollow: [User] = []
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return [] }
    let followingRef = FirebaseManager.shared.firestore.collection("Users").document(userID).collection("Following")
    followingRef.getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
      usersIFollow = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: User.self)
      }
    }
    
    return usersIFollow
  } // End of method fetchUsers()
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(fcmTokenData: [:])
  }
}
