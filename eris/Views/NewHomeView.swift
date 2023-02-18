//
//  NewHomeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/10/23.
//

import SwiftUI
import FirebaseMessaging
import FirebaseFirestoreSwift

struct NewHomeView: View {
  @AppStorage("log_status") var logStatus: Bool = false
  @AppStorage("showOnboardingView") var showOnboardingView: Bool = true
  @State var fcmTokenData: [String : Any] = [:]
  @State var selectedTab: Int = 0
  @StateObject var camModel: CameraViewModel = CameraViewModel()
  @StateObject var myData: MyData = MyData()
  
  // MARK: Error Details.
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  
  var body: some View {
    ZStack {
      TabView(selection: $selectedTab) {
        NewFeedView()
          .tag(0)
          .toolbarBackground(.hidden, for: .tabBar, .bottomBar, .navigationBar)
          .toolbar(.hidden, for: .bottomBar, .tabBar)
        
        MyProfileView(boujees: exampleLivePosts)
          .tag(1)
          .toolbarBackground(.hidden, for: .tabBar, .bottomBar, .navigationBar)
          .toolbar(.hidden, for: .bottomBar, .tabBar)
        
        AboutSheetView()
          .tag(2)
          .toolbarBackground(.hidden, for: .tabBar, .bottomBar, .navigationBar)
          .toolbar(.hidden, for: .bottomBar, .tabBar)
      }
      .overlay {
//        Text("usersIFollow: \(myData.usersIFollow.count)")
      }
      
      VStack {
        Spacer()
        HStack {
          Spacer()
          VStack {
            Image(systemName: "house")
            Text("Home")
              .font(.caption)
          }
            .onTapGesture {
              selectedTab = 0
            }
          Spacer()
          VStack {
            Image(systemName: "magnifyingglass")
            Text("Search")
              .font(.caption)
          }
            .onTapGesture {
              selectedTab = 1
            }
          Spacer()
          VStack {
            Image(systemName: "tray")
            Text("Tray")
              .font(.caption)
          }
            .onTapGesture {
              selectedTab = 2
            }
          Spacer()
        }
        .tint(.white)
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding()
        .offset(y: -10)
      }
      .frame(maxHeight: .infinity)
      .ignoresSafeArea()
    }
    .toolbar(.hidden, for: .bottomBar, .tabBar)
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
        myData.myUserProfile = await fetchCurrentUser()
        
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
      print("currentUser documentID: \(user.id)")
      return user
    } catch {
      // handle errors
    }
    
    print("Failed to fetch logged in user's data.")
    return nil
  }
  
  private func fetchUsersIFollow() async -> [User] {
    var users: [User] = []
    do {
      let querySnapshot = try await FirebaseManager.shared.firestore
        .collection("Users")
        .document(myData.myUserProfile!.firestoreID)
        .collection("Following").getDocuments()
      let documentsRef = querySnapshot.documents
      let temp = try documentsRef.compactMap({ QueryDocumentSnapshot in
        try QueryDocumentSnapshot.data(as: User.self)
      })
      users.append(contentsOf: temp)
      print("usersIFollow: \(users.count)")
      return users
    } catch {
      await setError(error)
    }
    print("Error Fetching usersIFollow!")
    return users
  } // End of method fetchUsers()
  
  // MARK: Display Errors Via ALERT
  private func setError(_ error: Error) async {
    // UI Must be updated on Main Thread.
    await MainActor.run(body: {
      errorMessage = error.localizedDescription
      showError.toggle()
    })
  }
}

struct NewHomeView_Previews: PreviewProvider {
  static var previews: some View {
    NewHomeView()
  }
}
