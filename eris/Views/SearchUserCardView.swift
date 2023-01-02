//
//  UserProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/30/22.
//

import SwiftUI

struct SearchUserCardView: View {
    @State var user: User
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
}

struct SearchUserCardView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserCardView(user: exampleUsers[0])
    }
}
