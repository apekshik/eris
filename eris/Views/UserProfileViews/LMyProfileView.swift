//
//  ProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//  Copyright © 2022 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct LMyProfileView: View {
  // Profile Data
  @State var myProfile: User? = nil
  @AppStorage("log_status") var logStatus: Bool = false
  
  // Review Data
  @State var reviews: [Post] = []
  
  // MARK: Error data
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  @State var isLoading: Bool = false
  
  // MARK: View Control data
  @State var showAppTitle: Bool = true
  @State var showAboutSheet: Bool = false
  @Binding var showCamera: Bool
  
  // MARK: Main View Body
  var body: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: false) {
        if myProfile != nil {
          ZStack {
            BackgroundView()
            foreground
          }
        } else {
          Text("")
            .onAppear { isLoading = true }
            .onDisappear() { isLoading  = false }
        }
      }
      .refreshable {
        // refreshes user data when view is pulled down
        myProfile = nil
        await fetchUserData()
        await fetchReviews()
      }
      .navigationTitle(myProfile?.fullName ?? "No Profile Loaded")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            // Actions:
            // 1. Logout
            // 2. Delete Account
            Button("Logout", action: logoutUser)
            
            Button("Delete Account", role: .destructive, action: deleteAccount)
            
            Button {
              showAboutSheet.toggle()
            } label: {
              HStack {
                Text("About The Developer(s)")
              }
            }
            
            Link(destination: URL(string: "https://www.privacypolicies.com/live/ba318495-b2b0-4f1c-af21-7bde81a37a81")!) {
              HStack {
                Text("Privacy Policy")
              }
            }
          } label: { // Label for Menu
            Image(systemName: "line.3.horizontal")
              .tint(.white)
              .scaleEffect(1.7)
            
          }
        }
      }
    }
    .sheet(isPresented: $showAboutSheet, content: {
      AboutSheetView()
        .presentationDetents([.medium, .large])
    })
    .overlay {
      LoadingView(show: $isLoading)
      
      // This is the title on the top left corner that dissappears in the navigation stack and reappears on return to home profile page.
      Text(showAppTitle ? "BOUJÈ" : "")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .font(.system(.title))
        .fontWeight(.black)
        .fontDesign(.serif)
        .padding([.horizontal], 20)
    }
    .alert(errorMessage, isPresented: $showError) {}
    .task {
      if myProfile != nil { return }
      // the .task modifier is like .onAppear, so fetches once in the beginning only.
      // MARK: Initial fetch of data for profile view.
      await fetchUserData()
      await fetchReviews()
    }
  }
  
  var foreground: some View {
    VStack {
      Button {
        showCamera.toggle()
      } label: {
        Image(systemName: "camera.fill")
          .resizable()
          .tint(.white)
          .frame(width: 50, height: 40)
      }
      // can safely use forced unwrapping since we checked for nil already.
      LivePostView(user: myProfile!)
      
      // Regular section follows Live Post section
      if reviews.count > 0 {
        reviewSection
      } else {
        EmptyMyProfileView()
      }
    }
  }
  
  var reviewSection: some View {
    VStack {
      Text("BOUJEEs".uppercased())
        .font(.system(.title))
        .fontWeight(.bold)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding([.horizontal, .top], 20)
      
      LazyVStack {
        ForEach(reviews, id: \.id) { review in
          NavigationLink {
            PostPageView(user: myProfile!, post: review, showName: false, comments: exampleComments)
              .onAppear{ withAnimation(.linear(duration: 0.1)) { self.showAppTitle = false } }
          } label: {
            PostCardView(user: myProfile!, post: review, showName: false)
          }
          .onAppear{ withAnimation { self.showAppTitle = true } }
          
        }
      } // End of LazyVStack
      
      DeveloperMastFooter()
    }
  }
  
  // MARK: Fetch User Data
  private func fetchUserData() async {
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
    guard let user = try? await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self) else { return }
    await MainActor.run(body: {
      myProfile = user
    })
  }
  
  // MARK: Logout of User Account
  private func logoutUser() {
    isLoading = true
    try? FirebaseManager.shared.auth.signOut()
    logStatus = false
  }
  
  // MARK: Delete entire User Account
  private func deleteAccount() {
    isLoading = true
    Task {
      do {
        let auth = FirebaseManager.shared.auth
        let db = FirebaseManager.shared.firestore
        guard let userID = auth.currentUser?.uid else { return }
        
        // delete User document from Firestore Database.
        try await db.collection("Users").document(userID).delete()
        // delete User's Auth account and set log status to false
        try await auth.currentUser?.delete()
        logStatus = false
      } catch {
        await setError(error)
      }
    }
  }
  
  // MARK: Fetch Reviews For Our User and store it in the reviews var.
  private func fetchReviews() async {
    // fetch all reviews from reviews collection associated with current user.
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
    let reviewsRef = FirebaseManager.shared.firestore.collection("Reviews")
    // Creates a query object. Next, we use the getDocuments() method to actually fetch the docs.
    reviewsRef.whereField("uid", isEqualTo: userID).getDocuments() { querySnapshot, error in
      
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      reviews = documents.compactMap({ queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: Post.self)
      })

    }
  }
  
  // MARK: Display Errors Via ALERT
  private func setError(_ error: Error) async {
    // UI Must be updated on Main Thread.
    await MainActor.run(body: {
      errorMessage = error.localizedDescription
      showError.toggle()
      isLoading = false
    })
  }

}

struct MyProfileView_Previews: PreviewProvider {
  static var previews: some View {
    LMyProfileView(myProfile: exampleUsers[0], showCamera: .constant(false))
  }
}
