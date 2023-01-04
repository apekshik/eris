//
//  FeedCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/3/23.
//

import SwiftUI

struct FeedCardView: View {
  @State var user: User?
  @State var review: Review
  @State var liked: Bool = false
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 10) {
          
          
          HStack {
            Text(user?.fullName ?? "")
              .font(.headline)
              .foregroundColor(.secondary)
            Text("\(review.rating) Star Rating")
              .font(.headline)
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .trailing)
          }
          
          // written review
          Text(review.comment)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)
            .lineLimit(3)
          
          // HStack under the written review.
          HStack {
            Text("Written by a \(review.relation)".uppercased())
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
        }
      }
      .padding()
    }
    .background(Color(hex: "#e6e5e1"))
    .cornerRadius(10)
    .shadow(radius: 5)
    .padding([.top, .horizontal])
    .onTapGesture(count: 2) {
      liked.toggle()
      let impactMed = UIImpactFeedbackGenerator(style: .medium)
      impactMed.impactOccurred()
    }
    .task {
      await fetchUser()
    }
  }
  
  private func fetchUser() async {
    let db = FirebaseManager.shared.firestore
    guard let temp = try? await db.collection("Users").document(review.uid).getDocument(as: User.self) else { return }
    
    await MainActor.run(body: {
      self.user = temp
    })
          
  }
}

struct FeedCardView_Previews: PreviewProvider {
  static var previews: some View {
    FeedCardView(user: exampleUsers[0], review: exampleReviews[0])
  }
}
