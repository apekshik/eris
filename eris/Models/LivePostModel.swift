//
//  Copyright © Apekshik Panigrahi. All Rights Reserved.
//  
//  LiveBoujeeModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/9/23.
//

import Foundation

struct LivePost: Codable, Identifiable, Hashable {
  var id = UUID() // To be able to iterate through a list of Review Items.
  let userID: String // associated uid in firestore. Tells which user the review is for.
  let authorID: String // id that tells which user wrote the review.
  let selfID: String // stores the it's own firestore id for quick reference.
  let createdAt: Date
  let text: String
  let authorUsername: String
  let recipientUsername: String
  let anonymous: Bool
  
  enum CodingKeys: String, CodingKey {
    case userID
    case authorID
    case selfID
    case createdAt
    case text
    case authorUsername
    case recipientUsername 
    case anonymous
  }
}
