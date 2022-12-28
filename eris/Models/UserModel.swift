//
//  UserModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//

import Foundation

// User model to store users in firestore database.
struct User: Codable, Identifiable  {
  var id = UUID()
  let firstName: String
  let lastName: String
  var fullName: String { // a computable property
    return firstName + " " + lastName
  }
  var userName: String
  let email: String
  
  enum CodingKeys: String, CodingKey {
    case firstName
    case lastName
//    case fullName: don't need to store this in the DB since we can always decode and compute this property.
    case userName
    case email
  }
}
