//
//  UserProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/30/22.
//

import SwiftUI
import FirebaseFirestore


struct UserProfileView: View {
  @State var user: User
  @State var reviews: [Review] = []
  @State var following: Bool = false
  @State var blocked: Bool = false
  @State var youAreBlockedStatus: Bool = false
  @State var followerCount: Int = 0
  
  // MARK: Error Details.
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  
  // Review Form Data
  @State var showReviewForm: Bool = false
  
  var body: some View {
      NavigationStack {
        if youAreBlockedStatus == false {
          fullBody
        } else {
          Text("You've been blocked by this person")
        }
      }
      .sheet(isPresented: $showReviewForm, content: {
        ReviewForm(user: user, show: $showReviewForm)
      })
      .task {
        youAreBlockedStatus = youAreBlocked()
        blocked = await checkBlockedStatus()
        
        fetchReviews(for: user)
        following = await updateFollowing() // check when the view loads if you're following the user already and update the following variable accordingly.
        
      }
      // Alert popup everytime there's an error.
      .alert(errorMessage, isPresented: $showError) {
        
      }
   
  }
  
  var fullBody: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      // Followers and Follow button go here
      // if you blocked this person, you shouldn't be able to follow/unfollow them, so this feature should be removed in that case using an if check.
      if !blocked {
        followerSection
      }
      
      LiveBoujeeView()
      
      // Set of Reviews start here (with Title ofcourse).
      // HStack is Reviews Section Header
      HStack {
        
        // Title for review section.
        Text("Boujees".uppercased())
          .font(.system(.title))
          .fontWeight(.bold)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .center)
          
        
        // Button to post a new review
        Button {
          showReviewForm = true
        } label: {
          Image(systemName: "plus.square.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .tint(.black)
        }
      }
      .padding([.horizontal, .top], 20)
      
      // Start of Review Cards
//          LazyVStack {
//            ForEach(reviews, id: \.id) { review in
//              ReviewCardView(user: user, review: review, showName: false)
//            }
//          }
      reviewSection
      
    }
    .navigationTitle(user.fullName)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Menu {
          // Actions:
          // 1. Logout
          // 2. Delete Account
          Button {
            // action
            handleBlocking()
            
          } label: {
            HStack {
              Image(systemName: blocked ? "person.fill.questionmark" : "person.fill.xmark")
              Text(blocked ? "Unblock" : "Block")
            }
          }
          
          Button {
            // action
          } label: {
            HStack {
              Image(systemName: "exclamationmark.triangle")
              Text("Report User")
            }
          }
          
        } label: { // Label for Menu
          HStack {
            Image(systemName: "shield.lefthalf.fill")
              .tint(blocked ? .red : .black)
          }
        }
      }
    }
  }
  var reviewSection: some View {
    LazyVStack {
      ForEach(reviews, id: \.id) { review in
        NavigationLink {
          ReviewPageView(user: user, review: review, showName: true)
        } label: {
          ReviewCardView(user: user, review: review, showName: true)
        }
      }
    } // End of LazyVStack
  }
  
  var followerSection: some View {
    HStack {
      VStack {
        Text("432 Followers")
      }
      Spacer()
      Button {
        // if you're following, you have to unfollow on button press,
        // else you have to follow on button press.
        if following == false { follow() }
        else { unfollow() }
        following.toggle()
        
      } label: {
        Text(following ? "Unfollow" : "Follow")
          .padding(8)
          .foregroundColor(.white)
          .background(.black)
          .cornerRadius(10)
      }
    }
    .padding([.horizontal], 20)
  }
  
  // MARK: helper function invoked upon clicking the follow button that sets new documents in the followings and followers subcollections in your and the user's document, respectively.
  private func follow() {
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
  
  // MARK: As the name implies, the method allows you to unfollow the user you're not interested in anymore.
  private func unfollow() {
    // Task lets you run an asynchronous chunk of code in a synchronous environment, i.e, a function that isn't declared async.
    Task {
      do {
        // get your ID.
        guard let myID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let db = FirebaseManager.shared.firestore
        
        // delete the user's doc from your followings subcollection.
        try await db.collection("Users").document(myID).collection("Following").document(user.firestoreID).delete()
        // delete your user doc from their followers subcollection.
        // MARK: Tried specifying the path in one single string instead of going down the collection().document().collection().document() path. See if this works.
        try await db.document("Users/\(user.firestoreID)/Followers/\(myID)").delete()
        print("Unfollowed user \(user.fullName)")
      } catch {
        await setError(error)
      }
    }
  }
  
  // MARK: Updates the following variable based on whether you're following the user or not.
  private func updateFollowing() async -> Bool {
    // Handy Note from Firestore Docs (Get Data Page): If there is no document at the location referenced by docRef, the resulting document will be empty and calling exists on it will return false.
    do {
      
      guard let myID = FirebaseManager.shared.auth.currentUser?.uid else { return false }
      let docRef = FirebaseManager.shared.firestore.collection("Users").document(myID).collection("Following").document(user.firestoreID)
      // checking to see if the documentSnapshot we're trying to fetch exists. Then we set following to true if it does exist (meaning the document exists and you're following this user) or set it to false if it doesn't.
      let docExists = try await docRef.getDocument().exists
      if docExists == true { return true }
      else { return false }
      
    } catch {
      await setError(error)
    }
    print("do {} block in updateFollowing() - UserProfileView - didn't execute??")
    return false
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
  
  // MARK: Returns whether the user you're looking at has you in their blocklist.
  private func youAreBlocked() -> Bool {
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
      // TODO: Please throw approriate errors!
      return false
    }
    return user.blockedUsers.contains(uid)
  }
  
  // MARK: Check in the beginning for blocked status of the user we've selected.
  private func checkBlockedStatus() async -> Bool {
    do {
      guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
        // TODO: PLEASE THROW APPROPRIATE ERROR
        return false
      }
      let db = FirebaseManager.shared.firestore
      let myProfile = try await db.collection("Users").document(uid).getDocument(as: User.self)
      if myProfile.blockedUsers.contains(user.firestoreID) { return true }
      else { return false }
    } catch {
      await setError(error)
    }
    print("do {} block in checkBlockedStatus() didn't execute??")
    return false
  }
  
  // MARK: Method that controls blocking/unblocking based on current blocked status of user we're viewing.
  private func handleBlocking() {
    if blocked == false {
      blockUser()
      unfollow()
      following.toggle()
    }
    else { unblockUser() }
    blocked.toggle()
  }
  
  // MARK: Block this user from your account.
  private func blockUser() {
    Task {
      do {
        let db = FirebaseManager.shared.firestore
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        try await db.collection("Users").document(uid).updateData(["blockedUsers": FieldValue.arrayUnion([user.firestoreID])])
        print("Blocked User \(user.fullName), ID: \(user.firestoreID)")
      } catch {
        await setError(error)
      }
    }
  }
  
  private func unblockUser() {
    Task {
      do {
        let db = FirebaseManager.shared.firestore
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        try await db.collection("Users").document(uid).updateData(["blockedUsers": FieldValue.arrayRemove([user.firestoreID])])
      } catch {
        await setError(error)
      }
    }
  }
  
  // MARK: Report user and mention why you're reporting them.
  private func reportUser() {
    
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
    UserProfileView(user: exampleUsers[0], reviews: exampleReviews)
  }
}
