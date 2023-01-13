//
//  CommentModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//

import Foundation

struct Comment: Identifiable, Codable {
  var id = UUID()
  let authorID: String
  let authorUserName: String
  let reviewID: String?
  let content: String
  let createdAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case authorID
    case authorUserName
    case reviewID
    case content
    case createdAt 
  }
}
