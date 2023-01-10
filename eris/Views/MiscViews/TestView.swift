//
//  TestView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//

import SwiftUI

struct TestView: View {
  @State var user: User = exampleUsers[0]
  @State var boujees: [LivePost]
  @State var scrollProxy: ScrollViewProxy? = nil
  @State var newContent: String = ""
  var body: some View {
    VStack {
      // ScrollView for all LivePosts.
      
      ScrollViewReader { proxy in
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack(alignment: .leading, spacing: 4) {
            ForEach(boujees, id: \.self) { boujee in
              Text("**\(boujee.anonymous ? "anon".uppercased() : boujee.authorUsername.lowercased())** \(boujee.text)")
                .font(.caption)
                .id(boujee.id)
            } // End of
            .onAppear {
              scrollProxy = proxy
            }
          }
        }
      }
      .padding(8)
      .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 270)
      .onChange(of: boujees) { _ in
        scrollProxy?.scrollTo(boujees.last?.selfID)
        scrollToBottom()
      }
      
      // Footer for Adding LivePosts.
      TextField("Type here...", text: $newContent)
        .textFieldStyle(.roundedBorder)
      Button {
        addPost()
      } label: {
        Text("Post")
      }
    }
    .background(Color(hex: "#f5f5f2"))
    .cornerRadius(5)
    .shadow(radius: 5)
  }
  
  private func addPost() {
    let newPost = LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: newContent, authorUsername: user.userName, anonymous: false)
    
    boujees.append(newPost)
    newContent = ""
  }
  private func scrollToBottom() {
    scrollProxy?.scrollTo(boujees.last!.id, anchor: .bottom)
  }
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TestView(boujees: exampleLivePosts)
  }
}
