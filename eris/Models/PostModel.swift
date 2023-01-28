//
//  ReviewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Codable, Identifiable, Hashable {
  @DocumentID var id = UUID().uuidString // To be able to iterate through a list of Review Items.
  let uid: String // associated uid in firestore. Tells which user the review is for.
  let authorID: String // id that tells which user wrote the review.
  let reviewID: String // stores the it's own firestore id for quick reference.
  let createdAt: Date
  let relation: String // type of relationship to the person who wrote the review.
  let caption: String
  let rating: Int
  let experienceWithThem: String?
  let imageURL: URL?
  let username: String? // username for whom the post was made.
  
  enum CodingKeys: String, CodingKey {
    case uid
    case authorID
    case reviewID
    case createdAt
    case relation
    case caption = "comment"
    case rating
    case experienceWithThem
    case imageURL
    case username
  }
}
