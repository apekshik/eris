//
//  FirebaseManager.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/11/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager: NSObject {
  let auth: Auth
  let firestore: Firestore
  
  static let shared = FirebaseManager()
  
  override init() {
    self.auth = Auth.auth()
    self.firestore = Firestore.firestore()
  }
  
  enum FirebaseError: Error {
    case currentUserIDNotFound
    case currentUserNotFound
  }
}
