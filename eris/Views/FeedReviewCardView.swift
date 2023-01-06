//
//  FeedCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/3/23.
//

import SwiftUI

struct FeedReviewCardView: View {
  @State var user: User?
  @State var review: Review
  @State var liked: Bool = false
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 10) {
          
          // Header Section
          HStack {
            Text(user?.fullName ?? "")
              .font(.headline)
              .fontWeight(.heavy)
//              .foregroundColor(.secondary)
            Text("\(review.rating) Star Rating")
              .font(.headline)
//              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .trailing)
          }
          .foregroundColor(.black)
          .padding([.horizontal, .top])
//          .opacity(0.6)
          
          // Review Body
          Text(review.comment)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.black)
            .foregroundColor(.black)
//            .foregroundColor(.black)
            .lineLimit(3)
            .padding([.horizontal])
          
          // HStack Footer
          HStack {
            Text("Written by a \(review.relation)".uppercased())
              .font(.caption)
              .foregroundColor(.black)
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
                  .scaleEffect(1.0)
              }
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .trailing)
          }
          .opacity(0.6)
          .padding()
          .background(Color(hex: "F5F5F4"))
//          .shadow(radius: 4)
        }
        
      }
//      .padding()
    }
//    .background(Color("Mellow Apricot"))
    .background(Color(hex: "E1E1DF"))
    .cornerRadius(5)
    .padding()
    .shadow(radius: 5)
    
    .onTapGesture(count: 2) {
            likeButtonPress()
      let impactMed = UIImpactFeedbackGenerator(style: .medium)
      impactMed.impactOccurred()
    }
  
    .task {
      await fetchUser()
    }
    .onAppear {
      checkLike()
    }
  }
  
  private func fetchUser() async {
    let db = FirebaseManager.shared.firestore
    guard let temp = try? await db.collection("Users").document(review.uid).getDocument(as: User.self) else { return }
    
    await MainActor.run(body: {
      self.user = temp
    })
          
  }
  
  // check if the post has already been liked. Update the liked variable appropriately.
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
    let likesRef = FirebaseManager.shared.firestore.collection("Users").document(review.uid).collection("Likes")
    Task {
      do {
        // delete the like that is associated with you and this specific review.
        let querySnapshot = try await likesRef
          .whereField("reviewID", isEqualTo: review.reviewID)
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
      let likeDocRef = FirebaseManager.shared.firestore.collection("Users").document(review.uid).collection("Likes").document()
      let newLike: Like = Like(likeID: likeDocRef.documentID, reviewID: review.reviewID, authorID: uid)
      
      try likeDocRef.setData(from: newLike)
    } catch {
      // TODO: handle errors
    }
  }
  
  private func unlike() {
    // Fetch your own uid
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
    // First get the "Likes" subcollection reference of the user whose review is being liked by you.
    let likesRef = FirebaseManager.shared.firestore.collection("Users").document(review.uid).collection("Likes")
    Task {
      do {
        // delete the like that is associated with you and this specific review.
        let querySnapshot = try await likesRef
          .whereField("reviewID", isEqualTo: review.reviewID)
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

struct FeedReviewCardView_Previews: PreviewProvider {
  static var previews: some View {
    FeedReviewCardView(user: exampleUsers[0], review: exampleReviews[0])
  }
}
