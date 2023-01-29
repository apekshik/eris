//
//  CommentSectionBodyView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//  Copyright © 2022 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct CommentSectionBodyView: View {
  @Binding var comments: [Comment]
  
  var body: some View {
    LazyVStack(spacing: 16) {
      ForEach(comments, id: \.id) { comment in
        HStack {
          VStack(alignment: .leading, spacing: 5) {
            HStack {
              Text("**@\(comment.authorUserName)**")
                .font(.caption)
              Text(comment.createdAt?.time(since: Date()) ?? "")
                .font(.caption2)
                .foregroundColor(.secondary)
              Spacer()
            }
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
    .onAppear {
      comments = comments.sorted(by: { com1, com2 in  (com1.createdAt ?? Date()).compare(com2.createdAt ?? Date()) == .orderedDescending })
    }
    .padding([.bottom, .horizontal])
  }
  
}

struct CommentSectionBodyView_Previews: PreviewProvider {
  static var previews: some View {
    CommentSectionBodyView(comments: .constant(exampleComments))
  }
}
