//
//  CommentModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//  Copyright © 2022 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
  @DocumentID var id: String? = UUID().uuidString
  let authorID: String
  let authorUserName: String
  let reviewID: String?
  let content: String
  let createdAt: Date?
  let chainPostID: String?
  
  enum CodingKeys: String, CodingKey {
    case authorID
    case authorUserName
    case reviewID
    case content
    case createdAt
    case chainPostID
  }
}
