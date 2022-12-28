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
  let uid: String?
  let firstName: String
  let lastName: String
  var fullName: String {
    return firstName + " " + lastName
  }
  let emailID: String
  
}
