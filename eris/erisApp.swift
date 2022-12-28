//
//  erisApp.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/7/22.
//

import SwiftUI
import Firebase

@main
struct erisApp: App {
  
  init() {
    FirebaseApp.configure()
  }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
