//
//  EmptyMyProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/7/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct EmptyMyProfileView: View {
    var body: some View {
      VStack(spacing: 12) {
        
        Image("ProfileEmpty")
          .resizable()
          .scaledToFit()
          .cornerRadius(10)
          .padding()
        
        Text("Looks Like you don't have any Boujees right now! This means none of your followers (yet) have posted a Boujee for you. So go ahead, start following friends (if you haven't already) and start Boujee-ing them!")
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

struct EmptyMyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyMyProfileView()
    }
}
