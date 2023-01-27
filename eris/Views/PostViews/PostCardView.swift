//
//  Copyright © 2023, Apekshik Panigrahi. All rights reserved.
//
//  ReviewView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCardView: View {
  @State var user: User
  @State var post: Post
  @State var showName: Bool
  @State var liked: Bool = false
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 10) {
          
          // Header
          HStack {
            VStack(alignment: .leading) {
              Text("\(user.fullName)")
                .font(.headline)
                .fontWeight(.heavy)
//                .foregroundColor(.secondary)
              Text("@\(user.userName)")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .shadow(color: .white, radius: 5)
//            Text("\(post.rating) Star Rating")
//              .font(.headline)
//              .foregroundColor(.secondary)
//              .frame(maxWidth: .infinity, alignment: .trailing)
            VStack(alignment: .trailing, spacing: 4) {
              Button {
                
              } label: {
                Text("Boujee Back".uppercased())
                  .fontWeight(.bold)
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding(8)
                  .background(.ultraThinMaterial)
                  .cornerRadius(10)
                
              }
              .shadow(color: .purple, radius: 5)
              .overlay {
                RoundedRectangle(cornerRadius: 10)
                  .stroke(
                    LinearGradient(
                      gradient: Gradient(colors: [.white.opacity(0.8), .white.opacity(0.2)]),
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.4
                  )
              }
              
              Text("6 hrs Left")
                .fontWeight(.bold)
                .font(.caption)
                .foregroundColor(.secondary)
            }
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
          Text(post.comment)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)
            .lineLimit(3)
            .padding(.horizontal)
          
          // HStack under the written review.
          HStack {
            Text("Posted by a \(post.relation)".uppercased())
              .font(.caption)
              .foregroundColor(.secondary)
            HStack(spacing: 20) {
              // Button for comments section.
              Button {
                // Action trigger when comments section button is pressed.
                
              } label: {
                Image(systemName: "bubble.right")
              }
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
          } // End of Boujee Footer
          .padding()
          .background(.thinMaterial)
        }
      }
    }
    
//    .background(Color(hex: "#e6e5e1"))
    .cornerRadius(10)
    .overlay {
      CardGradient()
    }
    .padding([.top, .horizontal])
    .onTapGesture(count: 2) {
      likeButtonPress()
      let impactMed = UIImpactFeedbackGenerator(style: .medium)
      impactMed.impactOccurred()
    }
    .onAppear {
      // check if this post is liked or not.
      checkLike()
    }
    
    
  }
  
  private func checkLike() {
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
  
  // bounce the card on long press.
  // Haven't used this anywhwere and isn't complete. Come back to it to polish it out.
  private func bounceAnimation() {
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    impactHeavy.impactOccurred()
    //        withAnimation(.spring()) {
    //            scale = CGSize(width: 1.05, height: 1.05)
    //        }
    //        withAnimation(.spring()) {
    //            scale = CGSize(width: 1, height: 1)
    //        }
  }
}

struct ReviewCardView_Previews: PreviewProvider {
  
  static var previews: some View {
    PostCardView(user: exampleUsers[0], post: exampleReviews[0], showName: true)
  }
}


