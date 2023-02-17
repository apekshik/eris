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
          if model.posts.count > 0 {
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
      if model.posts.count == 0 {
        model.fetchFeedPosts()
      }
      // the reason these print statements give 0 while the textviews and feed views all update
      // the data properly is because these print statements execute before the async downloads are
      // fethched. Once the data is fetched the views surely update but .task doesn't call the print statements
      // again.
      print("Printing from .task: \(myUserData.usersIFollow.count)")
      print("Printing from .task: \(model.posts.count)")
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
      ForEach(model.posts, id: \.self) { post in
        NavigationLink {
          // Destination
        } label: {
          FeedPostCardView(post: post)
        }
      }
    } // End of LazyVStack
  }
  

  // MARK: methods not needed. model: FeedViewModel handles fetching and storing posts for feed already.
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
