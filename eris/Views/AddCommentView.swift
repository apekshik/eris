//
//  AddCommentView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/1/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct AddCommentView: View {
  @Binding var show: Bool
  @Binding var comments: [Comment]
  @State var newCommentContent: String = ""
  @State var author: User? = nil
  let review: Review
  
  
  var body: some View {
    ZStack {
      if show {
        Group {
          // Just a blur background.
          Rectangle()
            .fill(.black.opacity(0.25))
            .ignoresSafeArea()
          
          // VStack for adding a comment.
          VStack(alignment: .leading, spacing: 8) {
            // axis: paramater makes a text field grow (vertically) dynamically with the content as long as there is enough space.
            TextField("Add Comment", text: $newCommentContent, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .lineLimit(4, reservesSpace: true)
            
            HStack {
              // To show the character count
              Text("\(newCommentContent.count) characters")
                .foregroundColor(.secondary)
              
              // spacer to push out the character count and post button to the far ends of the view.
              Spacer()
              
              // Button to submit post.
              Button {
                // Post comment to firestore and update
                Task {
                  await postComment()
                }
                show = false // close the add comment view.
              } label : {
                Text("Post")
                  .padding([.horizontal])
                  .padding([.vertical], 4)
                  .foregroundColor(.white)
                  .background(.black)
                  .cornerRadius(5)
              }
            }
            .frame(maxWidth: .infinity)
          }
          .padding()
          .frame(maxWidth: .infinity, minHeight: 150)
          .background(.white)
          .cornerRadius(10)
          .shadow(radius: 10)
          .padding()
        }
      }
    } // End of VStack
    .animation(.easeInOut(duration: 0.25), value: show)
  }
  
  // post comment to firestore
  private func postComment() async {
    Task {
      do {
        // in the case that some bombaclut tries to post an empty comment.
        guard newCommentContent.count > 0 else { return }
        
        // Populates the author variable.
        await fetchMyData()
        
        // We can use the bang (!) operator on the author var becauase we know we fetched the data and then tried to create a new Comment Instance.
        let newComment = Comment(authorID: author!.firestoreID,
                                 authorUserName: author!.userName,
                                 reviewID: review.reviewID,
                                 content: newCommentContent)
        
        // TODO: THis is again a temporary fix. Because in the case we want to order the comments a particular way from the server side, this won't work.
        comments.insert(newComment, at: 0)
        let db = FirebaseManager.shared.firestore
        try db.collection("Comments").document().setData(from: newComment)
        
        
      } catch {
        // do something about the errors.
      }
    }
  }
  
  // Update comments to be displayed.
  // TODO: here comments is unnecessarrily passed into the AddCOmment view from its parent ReivewPageView. See if you can find a way to avoid this and still manage to update the comments on the ReviewPageView.
  private func updateComments() async {
    print("Comments: \(comments.count)")
    let db = FirebaseManager.shared.firestore
    db.collection("Comments").whereField("reviewID", isEqualTo: review.reviewID).getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
      comments = documents.compactMap({ documentSnapshot in
        try? documentSnapshot.data(as: Comment.self)
      })
      print("Comments after update: \(comments.count)")
    }
  }
  
  // Fetch my User Data.
  private func fetchMyData() async {
      guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
      guard let user = try? await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self) else { return }
      
    await MainActor.run(body: {
        self.author = user
      })
  }
}

struct AddCommentView_Previews: PreviewProvider {
  static var previews: some View {
    AddCommentView(show: .constant(true), comments: .constant(exampleComments), review: exampleReviews[0])
  }
}
