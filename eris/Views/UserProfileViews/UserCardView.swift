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
  @Binding var usersIFollow: [User]
  var body: some View {
    NavigationLink {
      UserProfileView(user: user, usersIFollow: $usersIFollow)
    } label: {
      fullBody
    }
  }
  
  var fullBody: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {
        Text(user.fullName)
          .fontWeight(.bold)
        Text("@\(user.userName)")
          .foregroundColor(.secondary)
        
      }
      
      HStack {
        reviewButton
        Spacer()
  //        NavigationLink {
  //          UserProfileView(user: user)
  //        } label: {
  //          Image(systemName: "rectangle.portrait.and.arrow.forward") // chevron.forward.circle
  //            .resizable()
  //            .frame(width: 25, height: 25)
  //        }
        Image(systemName: "rectangle.portrait.and.arrow.forward") // chevron.forward.circle
          .resizable()
          .frame(width: 25, height: 25)
      }
    }
    .sheet(isPresented: $showReviewForm, content: {
      PostForm(user: user, show: $showReviewForm)
    })
    .padding()
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
      .foregroundColor(.white)
      .background(.black)
      .cornerRadius(4)
    }
  }
}

struct UserCardView_Previews: PreviewProvider {
  static var previews: some View {
    UserCardView(user: exampleUsers[0], usersIFollow: .constant([]))
  }
}
