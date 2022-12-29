//
//  ReviewView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct ReviewCardView: View {
    @State var user: User
    @State var review: Review
    @State var showName: Bool
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(showName ? user.fullName : "")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("\(review.rating) Star Rating")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Text(review.comment)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    HStack {
                        Text("Written by a \(review.relation)".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Image(systemName: "bubble.right")
                            Image(systemName: "heart")
                                .scaleEffect(1.1)
                        }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .padding()
            .background(Color(hex: "#e6e5e1"))
        }
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.top, .horizontal])
    }
}

struct ReviewCardView_Previews: PreviewProvider {

    static var previews: some View {
        ReviewCardView(user: exampleUser, review: exampleReviews[0], showName: true)
    }
}


