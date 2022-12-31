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
    @State var liked: Bool = false
    @State var scale: CGSize = CGSize(width: 1, height: 1)
    @State var fullReview: Bool = false
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
                    
                    // written review
                    Text(review.comment)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    
                    // HStack under the written review.
                    HStack {
                        Text("Written by a \(review.relation)".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack(spacing: 20) {
                            // Button for comments section.
                            Button {
                                // Action trigger when comments section button is pressed.
                            } label: {
                                Image(systemName: "bubble.right")
                            }
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
            }
            .padding()
        }
        .background(Color(hex: "#e6e5e1"))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.top, .horizontal])
        .scaleEffect(scale)
        .onTapGesture(count: 2) {
            liked.toggle()
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
        
    }
    
    // bounce the card on long press.
    // Haven't used this anywhwere and isn't complete. Come back to it to polish it out.
    private func bounceAnimation() {
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
        withAnimation(.spring()) {
            scale = CGSize(width: 1.05, height: 1.05)
        }
//        withAnimation(.spring()) {
//            scale = CGSize(width: 1, height: 1)
//        }
    }
}

struct ReviewCardView_Previews: PreviewProvider {

    static var previews: some View {
        ReviewCardView(user: exampleUser, review: exampleReviews[0], showName: true)
    }
}


