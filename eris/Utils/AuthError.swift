//
//  AuthError.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/7/23.
//

import Foundation

enum AuthError: Error {
  case noUIDFound
  case noUserLoggedIn
}

func test() {
  let err = AuthError.noUIDFound
  err.localizedDescription
}
