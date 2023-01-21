//
//  TFeedPostPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/18/23.
//

import SwiftUI

struct TFeedPostPageView: View {
  @State var user: User?
  @State var userID: String
  @State var post: Post
  @State var showName: Bool = true
  @State var liked: Bool = false
  @State var comments: [Comment] = []
  @State var showAddCommentView: Bool = false
  
  var body: some View {
    ZStack {
      BackgroundView()
      foreground
    }
  }
  
  var foreground: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: false){
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
          } // end of the comment section VStack.
          .background(.thinMaterial)
//          .background(.white)
          
          
        }
//        .background(Color(hex: "#e6e5e1"))
//        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay {
          CardGradient()
        }
        .padding([.top, .horizontal])
      }
      .refreshable {
//        fetchAllData()
      }
      .navigationTitle("Review".uppercased())
    }
    .overlay {
      AddCommentView(show: $showAddCommentView, comments: $comments, review: post)
    }
    .task {
//      fetchAllData()
    }
    
  }
  
  var reviewSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      
      HStack {
        Text(showName ? (user?.fullName ?? "") : "")
          .font(.headline)
          .foregroundColor(.secondary)
        Text("\(post.rating) Star Rating")
          .font(.headline)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding([.top, .horizontal])
      
      // Image if it exists.
//      if let postImageUrl = post.imageURL {
//        GeometryReader { proxy in
//          let size = proxy.size
//          WebImage(url: postImageUrl)
//            .resizable()
//            .scaledToFill()
//            .frame(width: size.width, height: size.height)
//        }
//        .clipped()
//        .frame(height: 400)
//      }
      
      // written review
      Text(post.comment)
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
}

struct TFeedPostPageView_Previews: PreviewProvider {
    static var previews: some View {
        TFeedPostPageView(user: exampleUsers[0], userID: "", post: exampleReviews[0])
    }
}
