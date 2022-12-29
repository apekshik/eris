//
//  ReviewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//

import Foundation

struct Review: Codable, Identifiable, Hashable {
  var id = UUID() // To be able to iterate through a list of Review Items.
  let uid: String // associated uid in firestore. Tells which user the review is for. 
  let relation: String // type of relationship to the person who wrote the review.
  let comment: String
  let rating: Int
  let experienceWithThem: String
  
  enum CodingKeys: String, CodingKey {
    case uid
    case relation
    case comment
    case rating
    case experienceWithThem
  }
}
