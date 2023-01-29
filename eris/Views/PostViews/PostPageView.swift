//
//  ReviewPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//  Copyright © 2022 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI
import SDWebImageSwiftUI

// TODO: Make this page refreshable.
struct PostPageView: View {
  @State var user: User
  @State var post: Post
  @State var showName: Bool = true
  @State var liked: Bool = false
  @State var comments: [Comment] = []
  @State var showAddCommentView: Bool = false
  
  var body: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: false){
        VStack { // Start of Boujee Card
          reviewSection
          
          VStack {
            commentSectionHeader
            
            if comments.count > 0 {
              CommentSectionBodyView(comments: $comments)
            } else {
              Text("No Comments Yet".uppercased())
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding([.bottom], 24)
            }
          }
          .background(.thinMaterial)
          
        } // End of Boujee Card.
        .cornerRadius(10)
        .overlay {
          CardGradient()
        }
        .padding([.top, .horizontal])
      }
      .refreshable {
        await fetchComments()
      }
      .navigationTitle("Review".uppercased())
    }
    .overlay {
      AddCommentView(show: $showAddCommentView, comments: $comments, review: post)
    }
    .task {
      // call a comments fetch method.
      await fetchComments()
    }
    
  }
  
  var reviewSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      
      HStack {
        Text(showName ? user.fullName : "")
          .font(.headline)
          .foregroundColor(.secondary)
        Text("\(post.rating) Star Rating")
          .font(.headline)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .trailing)
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
        Text("Written by a \(post.relation)".uppercased())
          .font(.caption)
          .foregroundColor(.secondary)
        HStack(spacing: 20) {
          // Button for Like/Unlike
          Button {
            likeButtonPress()
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
    .onAppear {
      checkLike()
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

  // MARK: Method to fetch comments for the specific review being viewed.
  private func fetchComments() async {
    let db = FirebaseManager.shared.firestore
    db.collection("Comments").whereField("reviewID", isEqualTo: post.reviewID).getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
      comments = documents.compactMap({ documentSnapshot in
        try? documentSnapshot.data(as: Comment.self)
      })
    }
  }

  
  // MARK: LIKE FUNCTIONALITY METHODS START HERE.
  private func checkLike() {
//    let docRef = FirebaseManager.shared.firestore.collection("Users").document("SF")
//
//    docRef.getDocument { (document, error) in
//        if let document = document, document.exists {
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//            print("Document data: \(dataDescription)")
//        } else {
//            print("Document does not exist")
//        }
//    }
    
    // Fetch your own uid
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
    // First get the "Likes" subcollection reference of the user whose review is being liked by you.
    let likesRef = FirebaseManager.shared.firestore.collection("Users").document(user.firestoreID).collection("Likes")
    Task {
      do {
        // delete the like that is associated with you and this specific review.
        let querySnapshot = try await likesRef
          .whereField("reviewID", isEqualTo: post.reviewID)
          .whereField("authorID", isEqualTo: uid)
          .getDocuments()
        
        if querySnapshot.isEmpty { liked = false }
        else { liked = true }
      } catch {
        // TODO: handle errors
      }
    }
  }
  
  private func likeButtonPress() {
    if liked == true {
      // call unlike method
      unlike()
    } else {
      // call like method.
      like()
    }
    
    liked.toggle()
  }
  
  private func like() {
    do {
      // Fetch your own uid
      guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
      
      // First get the "Likes" subcollection reference of the user whose review is being liked by you.
      let likeDocRef = FirebaseManager.shared.firestore.collection("Users").document(user.firestoreID).collection("Likes").document()
      let newLike: Like = Like(likeID: likeDocRef.documentID, reviewID: post.reviewID, authorID: uid)
      
      try likeDocRef.setData(from: newLike)
    } catch {
      // TODO: handle errors
    }
  }
  
  private func unlike() {
    // Fetch your own uid
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
    // First get the "Likes" subcollection reference of the user whose review is being liked by you.
    let likesRef = FirebaseManager.shared.firestore.collection("Users").document(user.firestoreID).collection("Likes")
    Task {
      do {
        // delete the like that is associated with you and this specific review.
        let querySnapshot = try await likesRef
          .whereField("reviewID", isEqualTo: post.reviewID)
          .whereField("authorID", isEqualTo: uid)
          .getDocuments()
        
        let temp = querySnapshot.documents
        for doc in temp {
          let l = try? doc.data(as: Like.self)
          try await likesRef.document(l!.likeID).delete()
        }
        
      } catch {
        // TODO: handle errors
      }
    }
  }
 
}

struct ReviewPageView_Previews: PreviewProvider {
  static var previews: some View {
    PostPageView(user: exampleUsers[0], post: exampleReviews[0], showName: true, comments: exampleComments)
  }
}
