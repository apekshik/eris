//
//  UserProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/30/22.
//

import SwiftUI

struct UserCardView: View {
    @State var user: User
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.fullName)
                .font(.headline)
                .fontWeight(.bold)
            Text("@\(user.userName)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
