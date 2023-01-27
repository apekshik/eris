//
//  EmptySearchView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/8/23.
//

import SwiftUI

struct EmptySearchView: View {
    var body: some View {
      VStack(spacing: 12) {
        
        Image("SearchEmpty")
          .resizable()
          .scaledToFit()
          .cornerRadius(10)
          .padding()
        
        Text("Looks Like you don't have any Followers right now! Start following friends by searching them up on the Search Bar and start Boujee-ing!")
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

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView()
    }
}
