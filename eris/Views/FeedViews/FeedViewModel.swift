//
//  FeedViewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/11/23.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
  @Published var posts: [Post] = []
  
  // MARK: User Data
  @Published var usersIFollow: [User] = []
  @Published var myData: User? = nil
  @Published var newPost: Post? = nil
  
  // PhotoPicker vars
  @Published var showPhotoPicker: Bool = false
  @Published var photoItem: PhotosPickerItem? = nil
  @Published var postImageData: Data?
  
  // MARK: Error Details.
  @Published var errorMessage: String = ""
  @Published var showError: Bool = false
  
  // MARK: View vars
  @Published var isLoading: Bool = false
  
  
  func addUsersTo(usersIFollow users: [User]) {
    usersIFollow.append(contentsOf: users)
  }
  
  func addMyUserData(profileData: User, usersIFollow users: [User]) {
    myData = profileData
    usersIFollow = users
  }
  
  func makePost(for recipient: User, by author: User) {
    isLoading = true
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
        let documentReference = db.collection("Posts").document()
        
        /// Step 1:  Upload image if any.
        let imageReferenceID = "\(userID)\(documentReference.documentID)\(Date())"
        let storageRef = FirebaseManager.shared.storage.reference().child("PostImages").child(imageReferenceID)
        
        
        
        let _ = try await storageRef.putDataAsync(postImageData!)
        let downloadURL = try await storageRef.downloadURL()
        
        let newPost = Post(authorUserID: author.firestoreID, authorUsername: author.userName,
                           recipientUserID: recipient.firestoreID, recipientUsername: recipient.userName,
                           imageURL: downloadURL,
                           caption: "",
                           isParent: true, isConnected: false, hasChain: false,
                           connectedPostID: "", connectedPostImageURL: nil,
                           connectedPostCaption: "",
                           createdAt: Date())
        
        /// After uploading image to storage, upload document for new post to firestore.
        try documentReference.setData(from: newPost)
        
        isLoading = false
      } catch {
        // Catch and handle errors.
      }
    }
  }
  
  func updatePhoto(selectedPhotoPickerItem : PhotosPickerItem?) {
    if let selectedPhotoPickerItem {
      Task {
        if let rawImageData = try? await selectedPhotoPickerItem.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
          
          await MainActor.run(body: {
            postImageData = compressedImageData
            photoItem = nil
          })
        }
      }
    }
  }
  
  func fetchFeedPosts() {
    isLoading = true
    Task {
      usersIFollow = await fetchUsersIFollow()
      posts = await fetchPosts(for: usersIFollow)
      // Handle Reviews here.
      isLoading = false
    }
  }
  
  func fetchUsersIFollow() async -> [User] {
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else {
      print("userID couldn't be fetched. fetchUsersIFollow() method in FeedView.")
      return []
    }
    let followingRef = FirebaseManager.shared.firestore.collection("Users").document(userID).collection("Following")
    var users: [User]
    do {
      let snapshot = try await followingRef.getDocuments()
      users = try snapshot.documents.compactMap { queryDocumentSnapshot in
        try queryDocumentSnapshot.data(as: User.self)
      }
      return users
    } catch {
      await setError(error)
    }
    print("Didn't return users through do block!")
    return []
  }
  
  private func fetchPosts(for users: [User]) async -> [Post] {
    do {
      let postRef = FirebaseManager.shared.firestore.collection("Posts")
      var posts: [Post] = []
      for author in users  {
        let querySnapshot = try await postRef
          .whereField("authorUserID", isEqualTo: author.firestoreID)
          .whereField("isParent", isEqualTo: true)
          .order(by: "createdAt", descending: true)
          .limit(to: 3)
          .getDocuments()
        let documentsRef = querySnapshot.documents
        let temp: [Post] = try documentsRef.compactMap({ QueryDocumentSnapshot in
          try QueryDocumentSnapshot.data(as: Post.self)
        })
        posts.append(contentsOf: temp)
      }
      return posts
    } catch {
      await setError(error)
    }
    
    return []
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
