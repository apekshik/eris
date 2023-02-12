//
//  ReviewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Codable, Identifiable, Hashable {
  @DocumentID var id = UUID().uuidString // To be able to iterate through a list of Review Items.
  let authorUserID: String // id to tell who made the post.
  let authorUsername: String // username of the person who made the post
  let recipientUserID: String // userID to tell who the post is for.
  let recipientUsername: String // username for whom the post was made.
  let imageURL: URL? // Image URL for this post.
  let caption: String // short caption if they'd like to add that.
  // The bool conditions below are enough to let me know what type of post it is. For example,
  // if a post is a parent and connected, then I know this post is the start of the chain AND his/her friend
  // posted back. If a post is not a parent and connected, it is the post that the friend posted back, and so on...
  let isParent: Bool // tells if the post is the start of a chain
  let isConnected: Bool // tells if the recipient boujee'd back.
  let hasChain: Bool // tells if the post has a chain attached to it.
  // we don't need to store the username for the connected post ID because it has to be the recipientUsername.
  let connectedPostID: String
  let connectedPostImageURL: URL?
  let connectedPostCaption: String
  //  The creeatedAt stores the same value as mostRecentPostTime when only the first post exists in the chain.
  let createdAt: Date // time of creation.
  
  
//  let chainPostIDs: [String] // Chain of Post IDs associated with this post.
//  let chainImageURLs: [URL]
  
  
  enum CodingKeys: String, CodingKey {
    case authorUserID
    case authorUsername
    case recipientUserID
    case recipientUsername
    case imageURL
    case caption = "comment"
    case isParent
    case isConnected
    case hasChain
    case connectedPostID
    case connectedPostImageURL
    case connectedPostCaption
    case createdAt
    
    
//    case chainPostIDs
//    case chainImageURLs
  }
}
