//
//  ChainPostModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import Foundation
import FirebaseFirestoreSwift

struct ChainPost: Codable, Identifiable, Hashable {
  @DocumentID var id = UUID().uuidString
  var authorID: String // ID of the author user who made the post.
  var authorPostID: String // ID of the post that the author made for their friend.
  var recipientID: String // ID of the recipient user who made the post.
  var recipientPostID: String // ID of the post that the friend made for the author.
  var chain: [String] // IDs of all the posts that are chained with the ChainPost.
  var mostRecentPostTime: Date?
  
  enum CodingKeys: String, CodingKey {
    case authorID
    case authorPostID
    case recipientID 
    case recipientPostID
    case chain
    
  }
}
