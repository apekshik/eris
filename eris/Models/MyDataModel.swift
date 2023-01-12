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
  @Published var fcmToken: FCMToken?
  
  func addFCMToken(from tokenData: [String : Any]) {
    fcmToken?.userID = nil
    fcmToken?.token  = tokenData["token"] as! String
    fcmToken?.createdAt = tokenData["createdAt"] as! Date
  }
  
  init(myUserProfile: User) {
    self.myUserProfile = myUserProfile
    usersIFollow = []
    usersThatFollowMe = []
    fcmToken = nil
  }
  
  init(fcmTokenData: FCMToken) {
    self.fcmToken = fcmTokenData
    myUserProfile = nil
    usersIFollow = []
    usersThatFollowMe = []
  }
  
  init() {
    myUserProfile = nil
    usersIFollow = []
    usersThatFollowMe = []
    fcmToken = nil
  }
}
