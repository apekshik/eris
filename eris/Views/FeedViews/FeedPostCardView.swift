//
//  FeedCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/3/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedPostCardView: View {
  @State var user: User?
  @State var post: Post
  @State var liked: Bool = false
  
  @State var gradientColors = [Color.purple, Color.black, Color(hex: "ff004c")]
  @State var startPoint = UnitPoint(x: 0, y: 0)
  @State var endPoint = UnitPoint(x: 0, y: 2)
  
  
  var body: some View {
    ZStack {
      background
      VStack {
        HStack {
          VStack(alignment: .leading, spacing: 10) {
            
            // Header Section
            HStack {
              Text("To \(user?.fullName ?? "")")
                .font(.headline)
                .fontWeight(.heavy)
              Spacer()
              Text("\(post.rating) Star Rating")
                .font(.headline)
  //              .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .foregroundColor(.white)
            .padding([.top, .horizontal], 16)
            .padding(.bottom, 12)
            .background(.thinMaterial)
  //          .padding([.horizontal, .top])
            
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
            
            // Review Body
            Text(post.comment)
              .font(.title)
              .fontWeight(.black)
              .frame(maxWidth: .infinity, alignment: .leading)
              .lineLimit(3)
              .padding(.horizontal)
              .foregroundColor(.white)
  //            .font(.title)
  //            .frame(maxWidth: .infinity, alignment: .leading)
  //            .fontWeight(.black)
  //            .foregroundColor(.black)
  //            .lineLimit(3)
  //            .padding([.horizontal])
            
            // HStack Footer
            HStack {
              Text("Written by a \(post.relation)".uppercased())
                .font(.caption)
                .foregroundColor(.white)
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
                    .foregroundColor(liked ? .pink : .white)
                }
              }
              .font(.headline)
              .tint(.white)
              .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(.thickMaterial)
            .opacity(0.6)
  //          .background(Color(hex: "F5F5F4"))
  //          .shadow(radius: 4)
          }
          
        }
  //      .padding()
      }
  //    .background(Color("Mellow Apricot"))
  //    .background(Color(hex: "E1E1DF"))
      .cornerRadius(5)
  //    .shadow(radius: 5)
      .overlay {
        CardGradient()
      }
      .padding()
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
  }
  
  struct CardGradient: View {
    var body: some View {
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
  }
  
  var background: some View {
    LinearGradient(gradient: Gradient(colors: self.gradientColors), startPoint: self.startPoint, endPoint: self.endPoint)
      .ignoresSafeArea()
      .blur(radius: 50)
      .opacity(0.4)
      .onAppear {
        withAnimation (.easeInOut(duration: 10)
          .repeatForever(autoreverses: true).speed(0.25)){
            self.startPoint = UnitPoint(x: 1, y: -1)
            self.endPoint = UnitPoint(x: 0, y: 1)
          }
      }
  }
  
  private func fetchUser() async {
    let db = FirebaseManager.shared.firestore
    guard let temp = try? await db.collection("Users").document(post.uid).getDocument(as: User.self) else { return }
    
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
    let likesRef = FirebaseManager.shared.firestore.collection("Users").document(post.uid).collection("Likes")
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
      let likeDocRef = FirebaseManager.shared.firestore.collection("Users").document(post.uid).collection("Likes").document()
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
    let likesRef = FirebaseManager.shared.firestore.collection("Users").document(post.uid).collection("Likes")
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

struct FeedPostCardView_Previews: PreviewProvider {
  static var previews: some View {
    FeedPostCardView(user: exampleUsers[0], post: exampleReviews[0])
  }
}
