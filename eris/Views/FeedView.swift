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
  
  var body: some View {
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
      fetchReviews()
    }
  }
  
  var feed: some View {
    LazyVStack {
      ForEach(reviews, id: \.self) { review in
        //        NavigationLink {
        //          ReviewPageView(user: users[review.authorID]!, review: review, showName: true, comments: exampleComments)
        //        } label: {
        //          ReviewCardView(user: users[review.authorID]!, review: review, showName: true)
        //        }
        Text(review.comment)
          .padding()
      }
    } // End of LazyVStack
  }
  
  private func fetchReviews() {
    let reviewRef = FirebaseManager.shared.firestore.collection("Reviews")
    reviewRef
      .whereField("uid", isEqualTo: "ETJq3FZgpjZNJpKIdMh4BUXcEJh2")
      .order(by: "createdAt", descending: true)
      .limit(to: 3)
      .getDocuments { querySnapshot, error in
        guard let documents = querySnapshot?.documents, error == nil else { return }
        
        reviews = documents.compactMap({ queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Review.self)
        })
        
      }
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
