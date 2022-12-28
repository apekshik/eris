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
  private let relations: [String] = ["Friend", "Ex-", "Co-worker"]
  
  // State variables.
  @State private var relation: String = ""
  @State private var comment: String = ""
  @State private var rating: Int = 0
  @State private var experienceWithThem: String = ""
  //  @State private var threeWords: String = ""
  
  // Bindings
  @Binding var firstName: String
  
  // Main UI View body
  var body: some View {
    VStack {
      
      // Title and Image (placeholder image for now).
      Image(systemName: "photo.circle")
        .resizable()
        .frame(maxWidth: 90, maxHeight: 90)
      Text("Reviewing \(firstName)")
        .font(.system(size: 26))
      
      // Form starts here.
      Form {
        
        // Personal information
        Section(header: Text("Personal Information")) {
          Text("Who are you to \(firstName)?")
//          TextField("Friend, Co-Worker, Ex-,...", text: $relation)
          Picker("Relation to them", selection: $relation) {
            ForEach(relations, id: \.self) { rel in
              Text(String(rel))
            }
          }
        }
        
        Section(header: Text("Comments"), footer: Text("* Yes, 0 star ratings for those extra special people in our lives :) ")
        ) {
          // Comments section
          Text("Here's a generous space for you to write down a beautiful comment")
          TextField("Type here", text: $comment)
          
          // One word description
          Text("Now, a word that describes your experience with them")
          TextField("One word please :)", text: $experienceWithThem)
          
          // Ratings picker
          Picker("Finally, an overall rating for this person :)", selection: $rating) {
            ForEach(ratings, id: \.self) { rating in
              Text(String(rating))
            }
          }
        }
        
        // Submit button
        Button("Submit Review") {
          // TODO: handle errors properly.
          handleFormSubmit()
        }
        .frame(maxWidth: .infinity, alignment: .center)
      } // End of Form.
    } // End of VStack
  } // End of main UI view body
  
  // TODO: convert this to throwable function with proper error handling.
  // takes all the data user submitted, puts in the ReviewModel, encodes it and sends it out to the firestore database.
  private func handleFormSubmit() {
    
    // guard to check if currentUserID can be extracted or not.
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else {
      // couldn't find signed in currentUserID
      print("Couldn't find Current Signed in UserID!")
//      throw FirebaseManager.FirebaseError.currentUserIDNotFound
      return
    }
    
    // create a new Review object with form input.
    let newReview = Review(uid: userID, relation: relation, comment: comment, rating: rating, experienceWithThem: experienceWithThem)
    
    
  }
}

struct ReviewForm_Previews: PreviewProvider {
  static var previews: some View {
    ReviewForm(firstName: .constant("Apekshik"))
  }
}
