//
//  ProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct MyProfileView: View {
  // Profile Data
  @State private var myProfile: User? = nil
  @AppStorage("log_status") var logStatus: Bool = false
  
  // Review Data
  @State var reviews: [Review] = []
  
  // MARK: Error data
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  @State var isLoading: Bool = false
  
  // MARK: View Control data
  @State var showAppTitle: Bool = true
  
  
  // MARK: Main View Body
  var body: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: false) {
        if myProfile != nil {
          VStack {
            // TODO: Implement this in next update!
            ProfileBoujeeView()
            
            Text("Reviews".uppercased())
              .font(.system(.title))
              .fontWeight(.bold)
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding([.horizontal, .top], 20)
            
            if reviews.count > 0 {
              // This view is defined below.
              reviewSection
            } else {
              Text("No Reviews for you yet!".uppercased())
                .foregroundColor(.secondary)
            }
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
      .navigationTitle("My Profile")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            // Actions:
            // 1. Logout
            // 2. Delete Account
            Button("Logout", action: logoutUser)
            
            Button {
              
            } label: {
              HStack {
                Text("Account Settings")
              }
            }
            
            Button("Delete Account", role: .destructive, action: deleteAccount)
            
          } label: { // Label for Menu
            Image(systemName: "line.3.horizontal")
              .tint(.black)
              .scaleEffect(1.7)
            
          }
        }
      }
    }
    .overlay {
      LoadingView(show: $isLoading)
      
      Text(showAppTitle ? "BOUJÈ" : "")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .font(.system(.largeTitle))
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
  
  var reviewSection: some View {
    LazyVStack {
      ForEach(reviews, id: \.id) { review in
        NavigationLink {
          ReviewPageView(user: myProfile!, review: review, showName: false, comments: exampleComments)
            .onAppear{ withAnimation(.linear(duration: 0.1)) { self.showAppTitle = false } }
        } label: {
          ReviewCardView(user: myProfile!, review: review, showName: false)
        }
        .onAppear{ withAnimation { self.showAppTitle = true } }
        
      }
    } // End of LazyVStack
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
        try? queryDocumentSnapshot.data(as: Review.self)
      })
      
      // MARK: Legacy way to do the same as above.
      //            if error == nil {
      //                if let snapshot = snapshot {
      //                    // documents is an array of document items. Each Document item is a dictionary
      //                    // that contains the fields as keys and their values are then extracted as shown below.
      //                    self.reviews = snapshot.documents.map { d in // d for document
      //                        // return a Review object. The map then returns an array of these Review objects which
      //                        // is then stored in the reviews state var.
      //                        return Review(uid: d["uid"] as? String ?? "",
      //                                      relation: d["relation"] as? String ?? "",
      //                                      comment: d["comment"] as? String ?? "",
      //                                      rating: d["rating"] as? Int ?? -1,
      //                                      experienceWithThem: d["experienceWithThem"] as? String ?? "")
      //                    }
      //                }
      //            } else {
      //                // Handle error
      //            }
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
    MyProfileView()
  }
}
