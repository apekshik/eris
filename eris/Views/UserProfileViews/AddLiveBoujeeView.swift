//
//  AddLiveBoujeeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/9/23.
//

import SwiftUI

struct AddLiveBoujeeView: View {
  @Binding var show: Bool
  @State var newContent: String = ""
  @State var forUser: User? = nil
  @State var author: User? = nil
  
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
            
            //Add Comment Header
            HStack {
              Text("Post a comment".uppercased())
                .fontWeight(.bold)
              Spacer()
              // Close Button
              Button {
                show = false
              } label: {
                Image(systemName: "xmark.square.fill")
                  .resizable()
                  .frame(width: 20, height: 20)
                  .tint(.black)
              }
            }
            
            // Body
            // axis: paramater makes a text field grow (vertically) dynamically with the content as long as there is enough space.
            TextField("Type here...", text: $newContent, axis: .vertical)
              .textFieldStyle(.roundedBorder)
              .lineLimit(4, reservesSpace: true)
            
            // Footer
            HStack {
              // To show the character count
              Text("\(newContent.count) Characters")
                .foregroundColor(.secondary)
              
              // spacer to push out the character count and post button to the far ends of the view.
              Spacer()
              
              // Button to submit post.
              Button {
                // Post comment to firestore and update
                Task {
                  await postBoujee()
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
  private func postBoujee() async {
    Task {
      do {
        // in the case that some bombaclut tries to post an empty comment.
        guard newContent.count > 0 else { return }
        
        // Populates the author variable.
        await fetchMyData()
        
        let db = FirebaseManager.shared.firestore
        let newBoujeeRef = db.collection("LiveBoujees").document()
        // We can use the bang (!) operator on the author var becauase we know we fetched the data and then tried to create a new Comment Instance.
        let newBoujee = LiveBoujee(userID: forUser!.firestoreID, authorID: author!.firestoreID, selfID: newBoujeeRef.documentID, createdAt: Date(), text: newContent)
        
        
        try db.collection("LiveBoujees").document(newBoujeeRef.documentID).setData(from: newBoujee)
      } catch {
        // do something about the errors.
      }
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

struct AddLiveBoujeeView_Previews: PreviewProvider {
    static var previews: some View {
      AddLiveBoujeeView(show: .constant(true))
    }
}
