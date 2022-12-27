//
//  ReviewForm.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/7/22.
//

import SwiftUI

struct ReviewForm: View {
  
  // Regular variables
  private let ratings: [Int] = [0, 1, 2, 3, 4, 5]
  
  // State variables.
  @State private var relation: String = ""
  @State private var comment: String = ""
  @State private var rating: Int = 0
  @State private var experience: String = ""
  //  @State private var threeWords: String = ""
  
  // Main UI View layout
  var body: some View {
    VStack {
      
      // Title and Image (placeholder image for now).
      Image(systemName: "photo.circle")
        .resizable()
        .frame(maxWidth: 90, maxHeight: 90)
      Text("Reviewing Apekshik")
        .font(.system(size: 26))
      
      // Form starts here.
      Form {
        
        // Personal information
        Section(header: Text("Personal Information")) {
          Text("Who are you to Apekshik?")
          TextField("Friend, Co-Worker, Ex-,...", text: $relation)
        }
        
        Section(header: Text("Comments"), footer: ReviewFormFooter) {
          // Comments section
          Text("Here's a generous space for you to write down a beautiful comment")
          TextField("Type here", text: $comment)
          
          // One word description
          Text("Now, a word that describes your experience with them")
          TextField("One word please :)", text: $experience)
          
          // Ratings picker
          Picker("Finally, an overall rating for this person :)", selection: $rating) {
            ForEach(ratings, id: \.self) { rating in
                Text(String(rating))
            }
          }
          
        }
        
        // Submit button
        Button("Submit Review") {
          // do something on submit.
        }
        .frame(maxWidth: .infinity, alignment: .center)
        

      } // end of Form.
    }
  } // End of UI View
  
  var ReviewFormFooter: some View {
    Text("* Yes, 0 star ratings for those extra special people in our lives :) ")
  }
}

struct ReviewForm_Previews: PreviewProvider {
  static var previews: some View {
    ReviewForm()
  }
}
