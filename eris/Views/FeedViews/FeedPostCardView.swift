//
//  FeedPostCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/16/23.
//

import SwiftUI

struct FeedPostCardView: View {
  @EnvironmentObject var model: FeedViewModel
  @EnvironmentObject var myUserData: MyData
  @State var post: Post
  
  var body: some View {
    imageView
  }
  
  var imageView: some View {
    Group {
      if let postImageData = model.postImageData, let image = UIImage(data: postImageData) {
        GeometryReader { proxy in
          let size = proxy.size
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .cornerRadius(5)
            .opacity(0.9)
            .onTapGesture {
            }
          // Delete Button
            .overlay(alignment: .topTrailing) {
              Button {
                withAnimation {
                  model.postImageData = nil
                }
              } label: {
                Image(systemName: "trash")
                  .fontWeight(.bold)
                  .tint(.white)
                  .padding(8)
                  .background(.ultraThinMaterial)
                  .cornerRadius(5)
              }
              .padding()
            }
          // Username on top left corner of the image selected.
            .overlay(alignment: .topLeading) {
              Text("\(post.authorUsername)→\(post.recipientUsername)")
                .font(.title)
                .fontWeight(.black)
                .padding(12)
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
