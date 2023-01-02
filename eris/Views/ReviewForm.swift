//
//  ReviewForm.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/7/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ReviewForm: View {
  
  // Regular variables.
  private let ratings: [Int] = [0, 1, 2, 3, 4, 5]
  private let relations: [String] = ["Friend", "Ex-", "Co-worker"]
  
  // State variables.
  @State private var relation: String = ""
  @State private var comment: String = ""
  @State private var rating: Int = 0
  @State private var experienceWithThem: String = ""
  //  @State private var threeWords: String = ""
  
  // First name of the person who a review form is being created for.
  @State var user: User
  
  @Binding var show: Bool
  
  // Main UI View body.
  var body: some View {
    VStack(spacing: 12) {
      // Title and Image (placeholder image for now).
      //            Image(systemName: "photo.circle")
      //                .resizable()
      //                .frame(maxWidth: 90, maxHeight: 90)
      VStack(spacing: 20) {
        Button {
          show = false
        } label: {
          Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 35, height: 35)
            .tint(.black)
        }
        Text("Review Form".uppercased())
          .font(.title)
          .fontWeight(.bold)
          .opacity(0.75)
      }
        
      
      // Form starts here.
      Form {
        
        // Personal information
        Section(header: Text("Personal Information")) {
          Text("Who are you to \(user.firstName)?")
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
          
          TextField("Type here", text: $comment, axis: .vertical)
            .lineLimit(5, reservesSpace: true)
          
          // One word description
          Text("Now, a word that describes your experience with them")
          TextField("One word please :)", text: $experienceWithThem)
          
          // Ratings picker
          Picker("Finally, an overall rating for this person :)", selection: $rating) {
            ForEach(ratings, id: \.self) { rating in
              Text(String(rating))
            }
          }
        } // End of Comments Section
        
        // Submit button
        Button("Submit") {
          // TODO: handle errors properly.
          handleFormSubmit()
          show = false
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(.black)
      } // End of Form.
      .frame(maxHeight: 610)
      .cornerRadius(10)
      .shadow(radius: 5)
    } // End of VStack
    .padding()

    
  } // End of main UI view body
  
  // TODO: convert this to throwable function with proper error handling.
  /// takes all the data user submitted, puts in the ReviewModel, encodes it and
  /// sends it out to the firestore database.
  private func handleFormSubmit() {
    Task {
      do {
      
        // guard to check if currentUserID can be extracted or not.
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else {
          // couldn't find signed in currentUserID
          print("Couldn't find Current Signed in UserID!")
          //      throw FirebaseManager.FirebaseError.currentUserIDNotFound
          return
        }
        
        /// create a document reference first because we need to store it as a field in the document
        /// itself. The reason you can get it before the document is created is because it's generated
        /// on the client when you create the document reference.
        let db = FirebaseManager.shared.firestore
        let documentReference = db.collection("Reviews").document()
        
        // create a new Review object with form input.
        let newReview = Review(uid: user.firestoreID,
                               authorID: userID,
                               reviewID: documentReference.documentID,
                               relation: relation,
                               comment: comment,
                               rating: rating,
                               experienceWithThem: experienceWithThem)
        
        // finally post the data for the review to firestore.
        try documentReference.setData(from: newReview)
        
      } catch {
          // Catch and handle errors.
      }
    }
  }
}

struct ReviewForm_Previews: PreviewProvider {
  static var previews: some View {
    ReviewForm(user: exampleUsers[0], show: .constant(true))
  }
}
