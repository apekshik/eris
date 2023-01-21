//
//  AddLiveBoujeeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/9/23.
//

import SwiftUI

struct AddLivePostView: View {
  @State var newContent: String = ""
  @State var forUser: User? = nil
  @State var author: User? = nil
  @State var anonymous: Bool = false
  
  var body: some View {
        VStack(alignment: .leading) {
          // axis: paramater makes a text field grow (vertically) dynamically with the content as long as there is enough space.
          TextField("Type here...", text: $newContent, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(2, reservesSpace: true)
          
          // Footer
          HStack {
            
            Toggle(isOn: $anonymous) {
              Text("Post Anonymously")
            }
            .tint(.black)
            .frame(maxWidth: 200)
            
            Spacer()
            
            // Button to submit post.
            Button {
              // Post comment to firestore and update
              Task {
                await postBoujee()
              }
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
        } // End of VStack
        .padding(.horizontal)
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(.thickMaterial)
//        .background(.white)
//        .shadow(radius: 5)
  }
  
  
  // post comment to firestore and empties textfield string.
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
        let newBoujee = LivePost(userID: forUser!.firestoreID, authorID: author!.firestoreID, selfID: newBoujeeRef.documentID, createdAt: Date(), text: newContent, authorUsername: author!.userName, anonymous: anonymous)
        
        
        try db.collection("LiveBoujees").document(newBoujeeRef.documentID).setData(from: newBoujee)
        
        await MainActor.run {
          newContent = ""
        }
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
      AddLivePostView()
    }
}
