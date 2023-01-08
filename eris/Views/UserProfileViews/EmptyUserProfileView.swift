//
//  EmptyUserProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/8/23.
//

import SwiftUI

struct EmptyUserProfileView: View {
  var body: some View {
    VStack(spacing: 12) {
      
      Image("ProfileEmpty")
        .resizable()
        .scaledToFit()
      
      Text("Looks Like this user doesn't have any Boujees right now! Come back later when they might have some, or even better – Boujee them now by clicking the Plus icon! ")
        .multilineTextAlignment(.center)
        .font(.title3)
        .fontDesign(.rounded)
        .padding()
        .foregroundColor(.secondary)
      
      Spacer()
      
      VStack {
        Text("Developed by".uppercased())
          .font(.caption2)
          .fontWeight(.semibold)
          .fontDesign(.rounded)
          .foregroundColor(.secondary)
        Text("Apekshik Panigrahi".uppercased())
          .font(.caption)
          .fontWeight(.semibold)
          .fontDesign(.rounded)
      }
    }
  }
}

struct EmptyUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyUserProfileView()
    }
}
