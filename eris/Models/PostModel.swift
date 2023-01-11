//
//  ReviewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable, Hashable {
  var id = UUID() // To be able to iterate through a list of Review Items.
  let uid: String // associated uid in firestore. Tells which user the review is for.
  let authorID: String // id that tells which user wrote the review.
  let reviewID: String // stores the it's own firestore id for quick reference.
  let createdAt: Date
  let relation: String // type of relationship to the person who wrote the review.
  let comment: String
  let rating: Int
  let experienceWithThem: String?
  let imageURL: URL?
  
  enum CodingKeys: String, CodingKey {
    case uid
    case authorID
    case reviewID
    case createdAt
    case relation
    case comment
    case rating
    case experienceWithThem
    case imageURL
  }
}
