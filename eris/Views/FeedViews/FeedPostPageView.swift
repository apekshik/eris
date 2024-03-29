//
//  FeedReviewPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedPostPageView: View {
  @State var user: User?
  @State var userID: String
  @State var post: Post
  @State var showName: Bool = true
  @State var liked: Bool = false
  @State var comments: [Comment] = []
  @State var showAddCommentView: Bool = false
  
  var body: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: false){
        ZStack {
          BackgroundView()
          foreground
        }
      }
      .refreshable {
        fetchAllData()
      }
      .navigationTitle("Review".uppercased())
    }
    .overlay {
      AddCommentView(show: $showAddCommentView, comments: $comments, review: post)
    }
    .task {
      fetchAllData()
    }
    
  }
  
  var foreground: some View {
    VStack {
      reviewSection
      
      // Comment section of the page.
      VStack {
        commentSectionHeader
        // checks if comments exist or have been fetched yet.
        if comments.count > 0 {
          CommentSectionBodyView(comments: $comments)
        } else {
          Text("No Comments Yet".uppercased())
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.bottom], 24)
        }
      }
//          .background(.white)
      .background(.thinMaterial)
      
    }
//        .background(Color(hex: "#e6e5e1"))
    .cornerRadius(10)
    .shadow(radius: 5)
    .overlay {
      CardGradient()
    }
    .padding([.top, .horizontal])
  }
  
  var reviewSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      
      HStack {
        Text(showName ? (user?.fullName ?? "") : "")
          .font(.headline)
          .foregroundColor(.secondary)
//        Text("\(post.rating) Star Rating")
//          .font(.headline)
//          .foregroundColor(.secondary)
//          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding([.top, .horizontal])
      
      // Image if it exists.
      if let postImageUrl = post.imageURL {
        GeometryReader { proxy in
          let size = proxy.size
          WebImage(url: postImageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
        }
        .clipped()
        .frame(height: 400)
      }
      
      // written review
      Text(post.caption)
        .font(.title)
        .fontWeight(.black)
        .foregroundColor(.primary)
        .padding(.horizontal)
      
      // HStack under the written review.
      HStack {
//        Text("Written by a \(post.relation)".uppercased())
//          .font(.caption)
//          .foregroundColor(.secondary)
        HStack(spacing: 20) {
          // Button for Like/Unlike
          Button {
            liked.toggle()
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
          } label: {
            Image(systemName: liked ? "heart.fill" : "heart")
              .scaleEffect(1.1)
          }
        }
        .font(.headline)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding([.horizontal, .bottom])
    }
    
  }
  
  var commentSectionHeader: some View {
    VStack {
      HStack {
        Text("Comments".uppercased())
          .font(.caption)
        Image(systemName: "bubble.right")
          .scaleEffect(0.8)
        
        Button {
          showAddCommentView = true
        } label: {
          Image(systemName: "plus.circle")
            .tint(.white)
            .opacity(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .opacity(0.65)
      Divider()
    }
    .padding([.top, .horizontal])
  }
  
  private func fetchAllData() {
    Task {
      user = await fetchUser(for: userID)
      comments = await fetchComments()
    }
  }
  
  private func fetchUser(for userID: String) async -> User? {
    do {
      let userRef = FirebaseManager.shared.firestore.collection("Users").document(userID)
      let user: User = try await userRef.getDocument(as: User.self)
      return user
    } catch {
      // TODO: handle errors thrown.
    }
    return nil
  }
  
  // MARK: Method to fetch comments for the specific review being viewed.
  private func fetchComments() async -> [Comment] {
    do {
      let db = FirebaseManager.shared.firestore
      let querySnapshot = try await db.collection("Comments").whereField("reviewID", isEqualTo: post.id).getDocuments()
      let comments: [Comment] = querySnapshot.documents.compactMap { QueryDocumentSnapshot in
        try? QueryDocumentSnapshot.data(as: Comment.self)
      }
      return comments
    } catch {
      // TODO: handle errors
    }
    
    return []
    
    /// Legacy way of fetching data using closures.
    //    let db = FirebaseManager.shared.firestore
    //    db.collection("Comments").whereField("reviewID", isEqualTo: review.reviewID).getDocuments { querySnapshot, error in
    //      guard let documents = querySnapshot?.documents, error == nil else { return }
    //
    //      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
    //      comments = documents.compactMap({ documentSnapshot in
    //        try? documentSnapshot.data(as: Comment.self)
    //      })
    //    }
  }
}

struct FeedPostPageView_Previews: PreviewProvider {
  static var previews: some View {
    FeedPostPageView(user: exampleUsers[0], userID: "", post: examplePost)
  }
}
