//
//  CommentSectionBodyView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//

import SwiftUI

struct CommentSectionBodyView: View {
  @Binding var comments: [Comment]
  
  var body: some View {
    LazyVStack(spacing: 16) {
      ForEach(comments, id: \.id) { comment in
        HStack {
          VStack(alignment: .leading, spacing: 5) {
            Text("**@\(comment.authorUserName)**")
              .font(.caption)
              .frame(maxWidth: .infinity, alignment: .leading)
            Text(comment.content)
              .font(.caption)
              .lineLimit(2)
//            HStack {
//              Text("Reply".uppercased())
//                .font(.caption)
//              Text("Send".uppercased())
//                .font(.caption)
//            }
//            .opacity(0.7)
          }
//          Button {
//            
//          } label: {
//            Image(systemName: "heart")
//              .frame(alignment: .trailing)
//          }
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
  
}

struct CommentSectionBodyView_Previews: PreviewProvider {
  static var previews: some View {
    CommentSectionBodyView(comments: .constant(exampleComments))
  }
}
