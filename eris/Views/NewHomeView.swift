//
//  NewHomeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/10/23.
//

import SwiftUI
import FirebaseMessaging

struct NewHomeView: View {
  @AppStorage("log_status") var logStatus: Bool = false
  @AppStorage("showOnboardingView") var showOnboardingView: Bool = true
  @State var fcmTokenData: [String : Any] = [:]
  @State var selectedTab: Int = 0
  @StateObject var camModel: CameraViewModel = CameraViewModel()
  @StateObject var myData: MyData = MyData()
  
  var body: some View {
    TabView(selection: $selectedTab) {   
      NewFeedView()
        .tag(0)
        .tabItem {
          Image(systemName: "house")
        }
        .toolbarBackground(.hidden, for: .navigationBar)
      
      MyProfileView(boujees: exampleLivePosts)
        .tag(1)
        .tabItem {
          Image(systemName: "magnifyingglass")
        }
      AboutSheetView()
        .tag(2)
        .tabItem {
          Image(systemName: "tray")
        }
    }
    .task {
      myData.myUserProfile = await fetchCurrentUser()
      myData.usersIFollow = await fetchUsersIFollow()
    }
    .environmentObject(camModel)
    .environmentObject(myData)
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
  func fetchCurrentUser() async -> User? {
    do {
      // Fetch the current logged in user ID if user is logged in.
      guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return nil }
      // Fetch user data from Firestore using the userID.
      let user = try await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self)
      print("successfully Fetched logged in user")
      return user
    } catch {
      // handle errors
    }
    
    print("Failed to fetch logged in user's data.")
    return nil
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
    
    print("Successfully fetched users I follow")
    return usersIFollow
  } // End of method fetchUsers()
}

struct NewHomeView_Previews: PreviewProvider {
  static var previews: some View {
    NewHomeView()
  }
}
