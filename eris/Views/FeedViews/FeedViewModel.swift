//
//  FeedViewModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/11/23.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI

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
  
  init() {
    Task {
      self.usersIFollow = await fetchUsersIFollow()
    }
  }
  
  func addUsersTo(usersIFollow users: [User]) {
    usersIFollow.append(contentsOf: users)
  }
  
  func addMyUserData(profileData: User, usersIFollow users: [User]) {
    myData = profileData
    usersIFollow = users 
  }
  
  func makePost() {
    
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
  
  func fetchFeedReviews() {
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
  
  func fetchPosts(for users: [User]) async -> [Post] {
    do {
      let reviewRef = FirebaseManager.shared.firestore.collection("Posts")
      var reviews: [Post] = []
      for user in users  {
        let querySnapshot = try await reviewRef
          .whereField("reciepientUserID", isEqualTo: user.id)
          .order(by: "createdAt", descending: true)
          .limit(to: 3)
          .getDocuments()
        let documentsRef = querySnapshot.documents
        let temp: [Post] = try documentsRef.compactMap({ QueryDocumentSnapshot in
          try QueryDocumentSnapshot.data(as: Post.self)
        })
        reviews.append(contentsOf: temp)
      }
      return reviews
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
