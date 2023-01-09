//
//  MyDataModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/8/23.
//

import Foundation

class MyData: Identifiable, ObservableObject {
  @Published var myUserProfile: User?
  @Published var usersIFollow: [User]
  @Published var usersThatFollowMe: [User]
  
  init(myUserProfile: User) {
    self.myUserProfile = myUserProfile
    usersIFollow = []
    usersThatFollowMe = []
  }
  
  init() {
    myUserProfile = nil
    usersIFollow = []
    usersThatFollowMe = []
  }
}
