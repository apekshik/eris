//
//  UserCardView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/2/23.
//

import SwiftUI

struct UserCardView: View {
  @State var user: User
  @State var showReviewForm: Bool = false
  
  var body: some View {
      HStack {
        VStack(alignment: .leading) {
            Text(user.fullName)
                .font(.headline)
                .fontWeight(.bold)
            Text("@\(user.userName)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        Spacer()
        Image(systemName: "chevron.right")
      }
  }
  
  var reviewButton: some View {
    Button {
      showReviewForm = true
    } label: {
      HStack {
        Image(systemName: "square.and.pencil") // rectangle.portrait.and.arrow.forward
          .resizable()
          .frame(width: 20, height: 20)
        
        Text("Boujee".uppercased())
      }
      .padding([.horizontal], 12)
      .padding([.vertical], 8)
      .background(.ultraThinMaterial)
      .cornerRadius(4)
    }
  }
}

struct UserCardView_Previews: PreviewProvider {
  static var previews: some View {
    UserCardView(user: exampleUsers[0])
  }
}
