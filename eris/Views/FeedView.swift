//
//  FeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/3/23.
//

import SwiftUI

struct FeedView: View {
  
  /// The users on the feed are stored in a hashtable with the key being the
  /// reviewID for the specific review shown on the feed.
  @State var users: [String: User] = [:]
  @State var reviews: [Review] = []

  var body: some View {
    ScrollView {
      if reviews.count > 0 {
        // This view is defined below.
        reviewSection
      } else {
        Text("No Reviews for you yet!".uppercased())
          .foregroundColor(.secondary)
      }
    }
  }
  
  var reviewSection: some View {
    LazyVStack {
      ForEach(reviews, id: \.self) { review in
        NavigationLink {
          ReviewPageView(user: users[review.authorID]!, review: review, showName: false, comments: exampleComments)
        } label: {
          ReviewCardView(user: users[review.authorID]!, review: review, showName: false)
        }
      }
    } // End of LazyVStack
  }
  
  // fetch reviews and fetch users and store users in a hashmap.
  private func fetchReviewsAndUsers() {
    
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
