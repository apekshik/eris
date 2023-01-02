//
//  ProfileStoryView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/29/22.
//

import SwiftUI

struct ProfileBoujeeView: View {
    var body: some View {
        VStack {
            Text("Live Boujees".uppercased())
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.secondary)
            
            VStack {
                Text("Coming Soon... ".uppercased())
                    .font(.title)
                    .fontWeight(.black)
            }
//            .frame(width: 200, height: 200)
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 250)
            .background(Color(hex: "#f5f5f2"))
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Text("*for unaware peasants, it's pronounced [boo-jee]")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#dededc"))
        .cornerRadius(10)
        .padding()
        .shadow(radius: 7)
    }
}

struct ProfileBoujeeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBoujeeView()
    }
}
