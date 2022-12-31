//
//  UserProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/30/22.
//

import SwiftUI

struct UserProfileView: View {
    @State var user: User
    @State var reviews: [Review] = []
    
    // MARK: Error Details.
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    
    var body: some View {
        VStack{
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // Followers and Follow button go here
                    HStack {
                        VStack {
                            Text("432 Followers")
                        }
                        Spacer()
                        Button {
                            // TODO: trigger action when follow button is pressed.
                            follow(user: user)
                        } label: {
                            Text("Follow")
                        }
                    }
                    .padding([.horizontal], 20)
                    
                    ProfileBoujeeView()
                    
                    // Set of Reviews start here (with Title ofcourse).
                    Text("Reviews".uppercased())
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding([.horizontal, .top], 20)
                    LazyVStack {
                        ForEach(reviews, id: \.id) { review in
                           ReviewCardView(user: user, review: review, showName: false)
                        }
                    }
                }
                .navigationTitle(user.fullName)
            }
        }
        .task {
            fetchReviews(for: user)
        }
        // Alert popup everytime there's an error.
        .alert(errorMessage, isPresented: $showError) {}
    }
    
    // MARK: helper function invoked upon clicking the follow button that sets new documents in the followings and followers subcollections in your and the user's document, respectively.
    private func follow(user: User) {
        // TODO: Check if the user passed in is the current user and then terminate the function call (You don't want to be following yourself).
        // Task lets you run an asynchronous chunk of code in a synchronous environment, i.e, a function that isn't declared async.
        Task {
            do {
                // get data for yourself as well as the user you're trying to follow.
                guard let myID = FirebaseManager.shared.auth.currentUser?.uid else { return }
                let db = FirebaseManager.shared.firestore
                let myData: User = try await db.collection("Users").document(myID).getDocument(as: User.self)
                
                // Add the user data to the followings subcollection within the your user's document.
                try  db.collection("Users").document(myID).collection("Following").document(user.firestoreID).setData(from: user) { error in
                    if error == nil {
                        // Success, so print to console!
                        print("Added new following \(user.fullName) to your account!")
                    }
                }
                // Add your user document to the other user's followers subcollection within their user document.
                try db.collection("Users").document(user.firestoreID).collection("Followers").document(myID).setData(from: myData) { error in
                    if error == nil {
                        // Sucess, so print to console!
                        print("Added new follower to their account!")
                    }
                }
                
            } catch {
               await setError(error)
            }
        }
        
    }
    
    // MARK: Fetch reviews specifically for the user you're looking at.
    private func fetchReviews(for user: User) {
        let db = FirebaseManager.shared.firestore
        db.collection("Reviews").whereField("uid", isEqualTo: user.firestoreID).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else { return }
            
            // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
            reviews = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Review.self)
            }
        }
    }
    
    // MARK: Display Errors Via ALERT
    private func setError(_ error: Error) async {
        // UI Must be updated on Main Thread.
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: exampleUser, reviews: exampleReviews)
    }
}
