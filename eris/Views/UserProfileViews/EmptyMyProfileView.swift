//
//  EmptyMyProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/7/23.
//

import SwiftUI

struct EmptyMyProfileView: View {
    var body: some View {
      VStack(spacing: 12) {
        
        Image("ProfileEmpty")
          .resizable()
          .scaledToFit()
        
        Text("Looks Like you don't have any Boujees right now! This means none of your followers (yet) have posted a Boujee for you. So go ahead, start following friends (if you haven't already) and start Boujee-ing them!")
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

struct EmptyMyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyMyProfileView()
    }
}
