//
//  ReportModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/5/23.
//

import Foundation

struct Report: Codable, Identifiable {
  var id = UUID()
  var authorID: String
  var userID: String
  var content: String
  var reviewID: String? // Optional reviewID
  
  
  enum CodingKeys: String, CodingKey {
    case authorID
    case userID
    case content
    case reviewID
  }
}
