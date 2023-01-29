//
//  CustomWebImage.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomWebImage: View {
  @Binding var authorFront: Bool
  @State var post: Post
  @State var front: Bool = false
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      WebImage(url: post.imageURL)
        .resizable()
        .overlay { // overlay for gradient border
          RoundedRectangle(cornerRadius: 10)
            .stroke(
              LinearGradient(
                gradient: Gradient(colors: [.white.opacity(0.8), .white.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 2
            )
        }
        .overlay { // overlay for Button to reverse order of photos.
          if front {
            Button {
              authorFront.toggle()
              print(authorFront)
            } label: {
              Image(systemName: "arrow.up.left.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .tint(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(8)
          }
        }
        .cornerRadius(10)
        .scaledToFit()
        .frame(width: size.width, height: size.height)
        .onTapGesture {
          authorFront.toggle()
        }
        
    }
    .clipped()
    .shadow(color: .white.opacity(0.6), radius: 5)
    .frame(height: 550)
    .padding(.horizontal, 20)
  }
}

struct CustomWebImage_Previews: PreviewProvider {
    static var previews: some View {
      CustomWebImage(authorFront: .constant(true), post: exampleReviews[0], front: true)
    }
}
