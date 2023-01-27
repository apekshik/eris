//
//  EmptyFeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/7/23.
//

import SwiftUI

struct EmptyFeedView: View {
    var body: some View {
      VStack(spacing: 12) {
        
        Image("FeedEmpty")
          .resizable()
          .scaledToFit()
          .cornerRadius(10)
          .padding()
        
        HStack {
          Text("Looks Like you don't have anything on your feed! Note that your feed is populated by boujees your friends and followers post. Start finding your friends by navigating to the search page. Once you begin following people your feed will automatically be populated with boujees.")
  //          .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .font(.title3)
            .fontDesign(.rounded)
            .padding()
          Spacer()
        }
        
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

struct EmptyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedView()
    }
}
