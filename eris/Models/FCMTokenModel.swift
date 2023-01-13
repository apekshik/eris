//
//  FCMTokenModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/13/23.
//

import Foundation
import FirebaseFirestoreSwift

struct FCMToken: Codable, Identifiable {
  @DocumentID var id: String? = UUID().uuidString
  var userID: String?
  var token: String
  var createdAt: Date
  
  enum CodingKeys: String, CodingKey {
    case userID
    case token
    case createdAt
  }
}
