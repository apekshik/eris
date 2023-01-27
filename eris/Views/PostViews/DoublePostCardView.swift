//
//  DoublePostCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/27/23.
//

import SwiftUI

struct DoublePostCardView: View {
  @State var authorUrl: String = "Mad1Large"
  @State var recipientUrl: String = "Apek1Large"
  @State var authorFront: Bool = true
    var body: some View {
      VStack(spacing: 0) {
        ZStack {
          LocalImage(url: authorFront ? $recipientUrl : $authorUrl, authorFront: $authorFront)
            .offset(x: -20, y: -30)
          LocalImage(url: authorFront ? $authorUrl : $recipientUrl, authorFront: $authorFront, front: true)
            .offset(x: 20, y: 30)
            
        }
        .padding(.horizontal, 8)
//        .background(.blue)
      }
//      .background(.ultraThinMaterial)
      .cornerRadius(10)
      .overlay {
        CardGradient()
      }
//      .shadow(color: .purple, radius: 5)
      .padding(.horizontal, 8)
    }
    
  
}

struct LocalImage: View {
  @Binding var url: String
  @Binding var authorFront: Bool
  @State var front: Bool = false
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      Image(url)
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
              Image(systemName: "arrow.counterclockwise.circle.fill")
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
    .shadow(color: .white, radius: 5)
    .frame(height: 570)
    .padding(.horizontal, 20)
  }
}

struct DoublePostCardView_Previews: PreviewProvider {
    static var previews: some View {
        DoublePostCardView()
    }
}
