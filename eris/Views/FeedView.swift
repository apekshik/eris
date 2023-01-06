//
//  FeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/3/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct FeedView: View {
  @State var reviews: [Review] = []
  @State var usersIFollow: [User] = []
  
  // MARK: Error Details.
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  
  var body: some View {
    NavigationStack {
      ScrollView {
        if reviews.count > 0 {
          // This view is defined below.
          feed
        } else {
          Text("No Reviews for you yet!".uppercased())
            .foregroundColor(.secondary)
        }
      }
      .refreshable {
        
      }
      .task {
        fetchFeedReviews()
      }
      .navigationTitle("Feed")
    }
    .alert(errorMessage, isPresented: $showError) {
      
    }
  }
  
  var feed: some View {
    LazyVStack(spacing: 8) {
      ForEach(reviews, id: \.self) { review in
        NavigationLink {
          // Destination
          FeedReviewPageView(userID: review.uid, review: review)
        } label: {
          FeedReviewCardView(review: review)
        }
      }
    } // End of LazyVStack
  }
  
  private func fetchFeedReviews() {
    Task {
      usersIFollow = await fetchUsersIFollow()
      reviews = await fetchReviews(for: usersIFollow)
      // Handle Reviews here.
    }
  }
  
  private func fetchUsersIFollow() async -> [User] {
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else {
      print("userID couldn't be fetched. fetchUsersIFollow() method in FeedView.")
      return []
    }
    let followingRef = FirebaseManager.shared.firestore.collection("Users").document(userID).collection("Following")
    var users: [User]
    do {
      let snapshot = try await followingRef.getDocuments()
      users = try snapshot.documents.compactMap { queryDocumentSnapshot in
        try queryDocumentSnapshot.data(as: User.self)
      }
      return users
    } catch {
      await setError(error)
    }
    print("Didn't return users through do block!")
    return []
  }
  
  
  private func fetchReviews(for users: [User]) async -> [Review] {
    do {
      let reviewRef = FirebaseManager.shared.firestore.collection("Reviews")
      
      
  //    reviewRef
  //            .whereField("uid", isEqualTo: user.firestoreID)
  //      .order(by: "createdAt", descending: true)
  //      .limit(to: 30)
  //      .getDocuments { querySnapshot, error in
  //        guard let documents = querySnapshot?.documents, error == nil else { return }
  //
  //        reviews = documents.compactMap({ queryDocumentSnapshot in
  //          try? queryDocumentSnapshot.data(as: Review.self)
  //        })
  //      }
      var reviews: [Review] = []
      for user in users  {
        var temp: [Review]
        let querySnapshot = try await reviewRef
          .whereField("uid", isEqualTo: user.firestoreID)
          .order(by: "createdAt", descending: true)
          .limit(to: 3)
          .getDocuments()
        let documentsRef = querySnapshot.documents
        temp = try documentsRef.compactMap({ QueryDocumentSnapshot in
          try QueryDocumentSnapshot.data(as: Review.self)
        })
        reviews.append(contentsOf: temp)
      }
      return reviews
    } catch {
      await setError(error)
    }
    
    return []
  }
  
  // MARK: Display Errors Via ALERT
  private func setError(_ error: Error) async {
    // UI Must be updated on Main Thread.
    await MainActor.run(body: {
      errorMessage = error.localizedDescription
      showError.toggle()
    })
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
