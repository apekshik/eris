//
//  LikeModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/4/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Like: Codable, Identifiable {
  let id = UUID()
  let likeID: String
  let reviewID: String // the ID for the review that the like is associated to.
  let authorID: String // ID associated with the user who created the like, i.e, tapped the like button.
  
  enum CodingKeys: String, CodingKey {
    case likeID
    case reviewID
    case authorID
  }
}
