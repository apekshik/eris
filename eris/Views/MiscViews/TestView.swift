//
//  TestView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//

import SwiftUI

struct TestView: View {
    @State var comments: [Comment]
    var body: some View {
        if comments.count > 0 {
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
                            HStack {
                                Text("Reply")
                                    .font(.caption)
                                Text("Send")
                                    .font(.caption)
                            }
                        }
                        Image(systemName: "heart")
                            .frame(alignment: .trailing)
                    }
                }
            }
            .padding()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(comments: exampleComments)
    }
}
