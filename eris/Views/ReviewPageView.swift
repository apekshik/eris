//
//  ReviewPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/31/22.
//

import SwiftUI

struct ReviewPageView: View {
    @State var user: User
    @State var review: Review
    @State var showName: Bool = true
    @State var liked: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    reviewSection
                    
        //            commentSection
                    VStack {
                        HStack {
                            Text("Comments".uppercased())
                                .font(.caption)
                            Image(systemName: "bubble.right")
                                .scaleEffect(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .opacity(0.65)
                    }
                    .padding(12)
                    .background(.white)
                }
                .background(Color(hex: "#e6e5e1"))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding([.top, .horizontal])
            }
            .navigationTitle("Review".uppercased())
        }
        
    }
    
    var reviewSection: some View {
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
            
            // written review
            Text(review.comment)
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.primary)
            
            // HStack under the written review.
            HStack {
                Text("Written by a \(review.relation)".uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 20) {
                    // Button for Like/Unlike
                    Button {
                        liked.toggle()
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    } label: {
                        Image(systemName: liked ? "heart.fill" : "heart")
                            .scaleEffect(1.1)
                    }
                }
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
    }
    
//    var commentSection: some View {
//
//    }
}

struct ReviewPageView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewPageView(user: exampleUser, review: exampleReviews[0], showName: true)
    }
}
