//
//  FirebaseManager.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/11/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class FirebaseManager: NSObject {
  let auth: Auth
  let firestore: Firestore
  let storage: Storage
  
  static let shared = FirebaseManager()
  
  override init() {
    self.auth = Auth.auth()
    self.firestore = Firestore.firestore()
    self.storage = Storage.storage()
  }
  
  enum FirebaseError: Error {
    case currentUserIDNotFound
    case currentUserNotFound
  }
}
