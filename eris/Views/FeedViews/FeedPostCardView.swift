//
//  FeedPostCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/16/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedPostCardView: View {
  @EnvironmentObject var model: FeedViewModel
  @EnvironmentObject var myUserData: MyData
  @State var post: Post
  
  var body: some View {
    imageView
  }
  
  var imageView: some View {
    Group {
      // Image if it exists.
      if let postImageUrl = post.imageURL {
        GeometryReader { proxy in
          
          let size = proxy.size
          WebImage(url: postImageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .cornerRadius(10)
            .opacity(0.9)
            // Username on top left corner of the image selected.
            .overlay(alignment: .topLeading) {
              HStack(spacing: 0) {
                Text("\(post.authorUsername.lowercased())→\(post.recipientUsername.lowercased())")
                  .tint(.white)
                  .font(.caption)
                  .fontWeight(.black)
                Text(" • \(post.createdAt.time(since: Date()))")
                  .foregroundColor(.secondary)
                  .font(.caption)
                  .fontWeight(.heavy)
              }
              .padding(8)
            }
        }
        .clipped()
        .frame(height: 450)
        .padding()
      }
    }
  }
}

struct FeedPostCardView_Previews: PreviewProvider {
  static var previews: some View {
    FeedPostCardView(post: examplePost)
  }
}
