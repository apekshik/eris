//
//  EmptyUserProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/8/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct EmptyUserProfileView: View {
  var body: some View {
    VStack(spacing: 12) {
      
      Image("ProfileEmpty")
        .resizable()
        .scaledToFit()
        .cornerRadius(10)
        .padding()
      
      Text("Looks Like this user doesn't have any Boujees right now! Come back later when they might have some, or even better – Boujee them now by clicking the Plus icon! ")
        .multilineTextAlignment(.center)
        .font(.title3)
        .fontDesign(.rounded)
        .padding()
        .foregroundColor(.secondary)
      
      Spacer()
      
      DeveloperMastFooter()
    }
  }
}

struct EmptyUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyUserProfileView()
    }
}
