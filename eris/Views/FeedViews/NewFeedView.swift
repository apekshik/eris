//
//  NewFeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/9/23.
//

import SwiftUI

struct NewFeedView: View {
  @State var textInput: String = ""
  @State var userSelected: User? = nil
  @State var showCamera: Bool = false
  @State var showMakePostView: Bool = false
  
  @State var posts: [Post] = [] 
  @StateObject var model: FeedViewModel = FeedViewModel()
  @EnvironmentObject var myUserData: MyData
  @EnvironmentObject var camModel: CameraViewModel
  
  // MARK: Error Details.
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  
  var body: some View {
    NavigationStack {
      ZStack {
        GradientBackgroundFeed()
          .opacity(0.6)
        ScrollView {
          headerButtons
          
          Text(myUserData.myUserProfile?.userName ?? "None")
          Text("Number of usersIfollow: \(myUserData.usersIFollow.count)")
          Text("Number of posts fetched: \(posts.count)")
          if posts.count > 0 {
            feed
              .environmentObject(model)
          } else {
            EmptyFeedView()
          }
          
        }
        .searchable(text: $textInput, placement: .navigationBarDrawer)
        .onChange(of: model.postImageData) { newValue in
          if newValue != nil {
            showMakePostView = true
          }
        }
        .onChange(of: camModel.photo) { newValue in
          if newValue != nil {
            model.postImageData = newValue?.compressedData
          }
        }
      }
      .toolbarBackground(.hidden, for: .navigationBar)
    }
    .task {
      await fetchPostsForFollowedUsers()
    }
    .sheet(isPresented: $showCamera, content: {
      CameraView(showCameraView: $showCamera)
    })
    .fullScreenCover(isPresented: $showMakePostView) {
      FeedViewPostView(model: model, showMakePostView: $showMakePostView)
    }
    .photosPicker(isPresented: $model.showPhotoPicker, selection: $model.photoItem)
    .onChange(of: model.photoItem) { newValue in
      model.updatePhoto(selectedPhotoPickerItem: newValue)
    }
    .overlay {
      LoadingView(show: $model.isLoading)
    }
//    .task { model.usersIFollow = await model.fetchUsersIFollow() }
    .refreshable {
      // do stuff to refresh
    }
  }
  
  var headerButtons: some View {
    HStack {
      // Image Picker
      Button {
        model.showPhotoPicker = true
      } label: {
        HStack {
          Image(systemName: "photo.on.rectangle.angled")
        }
      }
      Spacer()
      // Camera Button
      Button {
        print("Button Pressed!")
        showCamera.toggle()
      } label: {
        Image(systemName: "camera")
      }
    }
    .tint(.white)
    .padding()
  }
  
  var feed: some View {
    LazyVStack(spacing: 8) {
      ForEach(posts, id: \.self) { post in
        NavigationLink {
          // Destination
        } label: {
          FeedPostCardView(post: post)
        }
      }
    } // End of LazyVStack
  }
  
  func fetchPostsForFollowedUsers() async {
      let users = myUserData.usersIFollow
      let fetchedPosts = await fetchPosts(for: users)
      posts = fetchedPosts
  }
  
  private func fetchPosts(for users: [User]) async -> [Post] {
    do {
      let postRef = FirebaseManager.shared.firestore.collection("Posts")
      
      var posts: [Post] = []
      for author in users  {
        var temp: [Post]
        let querySnapshot = try await postRef
          .whereField("authorUserID", isEqualTo: author.firestoreID)
          .whereField("isParent", isEqualTo: true)
          .order(by: "createdAt", descending: true)
          .limit(to: 3)
          .getDocuments()
        let documentsRef = querySnapshot.documents
        temp = try documentsRef.compactMap({ QueryDocumentSnapshot in
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

struct NewFeedView_Previews: PreviewProvider {
  static var previews: some View {
    NewFeedView()
  }
}
