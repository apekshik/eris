//
//  FeedViewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/11/23.
//

import Foundation


class FeedViewModel: ObservableObject {
  @Published var posts: [Post]
  
  init() {
    self.posts = []
  }
}
