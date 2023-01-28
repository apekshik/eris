//
//  TFeedReviewCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/6/23.
//

import SwiftUI

struct TFeedReviewCardView: View {
  @State var user: User?
  @State var review: Post
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
          Text(review.caption)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.black)
            .foregroundColor(Color("Linen"))
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
//                likeButtonPress()
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
          .background(Color("Bone"))
          .shadow(radius: 4)
        }
        
      }
//      .padding()
    }
//    .background(Color("Mellow Apricot"))
    .background(Color("Princeton Orange"))
    .cornerRadius(5)
    .padding()
//    .shadow(radius: 5)
    
    .onTapGesture(count: 2) {
      //      likeButtonPress()
      let impactMed = UIImpactFeedbackGenerator(style: .medium)
      impactMed.impactOccurred()
    }
  }
}

struct TFeedReviewCardView_Previews: PreviewProvider {
    static var previews: some View {
        TFeedReviewCardView(user: exampleUsers[0], review: exampleReviews[0], liked: false)
    }
}
