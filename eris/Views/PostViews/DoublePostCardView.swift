//
//  DoublePostCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/27/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct DoublePostCardView: View {
  @State var authorUrl: String = "Mad1Large"
  @State var authorCreatedAt: String = "34 mins ago"
  @State var recipientUrl: String = "Apek1Large"
  @State var recipientCreatedAt: String = "Just now"
  @State var authorFront: Bool = true
  @State var timeLeft: String = "6 hrs"
  
  @State var chainPost: ChainPost
  @State var authorPost: Post
  @State var recipientPost: Post
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("\(recipientPost.username!) x \(authorPost.username!)")
          .font(.caption)
          .fontWeight(.bold)
        
          .padding([.top, .leading, .bottom], 8)
        Text(" • \(timeLeft) Left")
          .font(.caption)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity, alignment: .leading)
          .foregroundColor(.secondary)
      }
      ZStack {
//        LocalImage(url: authorFront ? $recipientUrl : $authorUrl, authorFront: $authorFront)
//          .offset(x: -20, y: -30)
//        LocalImage(url: authorFront ? $authorUrl : $recipientUrl, authorFront: $authorFront, front: true)
//          .offset(x: 20, y: 30)
        CustomWebImage(authorFront: $authorFront, post: authorFront ? recipientPost : authorPost)
        CustomWebImage(authorFront: $authorFront, post: authorFront ? recipientPost : authorPost, front: true)
      }
      .padding(.horizontal, 8)
      //        .background(.blue)
      Button { // button to continue boujee chain.
        
      } label: {
        Image(systemName: "plus.app.fill")
          .resizable()
          .background(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.7), .pink.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        //            .cornerRadius(14)
          .frame(width: 40, height: 40)
          .tint(.black)
        
      }
      .cornerRadius(8)
      .overlay { // overlay for gradient border
        RoundedRectangle(cornerRadius: 10)
          .stroke(
            LinearGradient(
              gradient: Gradient(colors: [.white.opacity(0.8), .white.opacity(0.2)]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1
          )
      }
      .shadow(color: Color("Princeton Orange"), radius: 5)
      .offset(y: -20)
    }
    //      .background(.ultraThinMaterial)
    .cornerRadius(10)
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.white.opacity(0.8), .black]),
            startPoint: .top,
            endPoint: .bottom
          ),
          lineWidth: 1
        )
    }
    .padding(.horizontal, 8)
  }
}

struct DoublePostCardView_Previews: PreviewProvider {
  static var previews: some View {
    DoublePostCardView(chainPost: exampleChainPosts[0], authorPost: exampleReviews[0], recipientPost: exampleReviews[1])
  }
}
