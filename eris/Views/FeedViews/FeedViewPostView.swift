//
//  FeedViewPostView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/12/23.
//

import SwiftUI

struct FeedViewPostView: View {
  // MARK: Search feature vars.
  @State var searchKeyword: String = ""
  @State var userQueries: [User] = []
  @Environment(\.dismissSearch) var dismissSearch
  @Environment(\.isSearching) var isSearching
  
  @ObservedObject var model: FeedViewModel
  @EnvironmentObject var myUserData: MyData
  @State var userSelected: User? = nil
  @State var showCamera: Bool = false
  @Binding var showMakePostView: Bool
  
  // [MAIN BODY STARTS HERE]
  var body: some View {
    // creating a binding so that fetchUser(containing) is called whenever the keyword changes.
    // TODO: Read more on this. It's kinda confusing how this works right now.
    let keywordBinding = Binding<String> (
      get: {
        searchKeyword
      },
      set: {
        searchKeyword = $0
        fetchUsers(containing: searchKeyword)
      })
    
    NavigationStack {
      ScrollView {
        ZStack { // ZStack to overlay searchBar results on the current view
          VStack {
            headerButtons
            
            imageAndPostButton
          }
          
          if userQueries.count > 0 {
            searchBarResults
          }
        }
      }
      .navigationTitle("Boujee your friend".uppercased())
    } // [End of outer VStack]
    .searchable(text: keywordBinding, prompt: "Find your friend to tag...")
    .sheet(isPresented: $showCamera) {
      CameraView(showCameraView: $showCamera)
    }
  } // [End of NavigationStack]
  
  // Search Bar results List.
  var searchBarResults: some View {
    VStack {
      LazyVStack(alignment: .leading) {
        ForEach(userQueries, id: \.id) { user in
          SearchUserCardView(user: user)
            .padding([.horizontal], 12)
            .padding([.vertical], 8)
            .onTapGesture {
              userSelected = user
              searchKeyword = ""
              userQueries = []
              dismissSearch()
              hideKeyboard()
            }
        }
      }
      .background(.thinMaterial)
      .cornerRadius(10)
      .padding()
      
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    //    .background(.ultraThinMaterial)
    .zIndex(userQueries.count > 0 ? 1 : 0)
  }
  
  var headerButtons: some View {
    HStack {
      
      // Image Picker Button
      Button {
        showMakePostView = false
        model.showPhotoPicker = true
      } label: {
        VStack {
          Image(systemName: "photo.on.rectangle.angled")
          Text("Reselect")
        }
      }
      Spacer()
      
      // Camera Button
      Button {
        print("Camera Button Pressed!")
        showCamera.toggle()
      } label: {
        VStack {
          Image(systemName: "camera")
          Text("Recapture")
        }
      }
    } // [End of Hstack]
    .tint(.white)
    .padding()
  }
  
  
  var imageAndPostButton: some View {
    VStack {
      if let postImageData = model.postImageData, let image = UIImage(data: postImageData) {
        GeometryReader { proxy in
          let size = proxy.size
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .cornerRadius(5)
            .opacity(0.9)
            .onTapGesture {
            }
            // Delete Button
            .overlay(alignment: .topTrailing) {
              Button {
                withAnimation {
                  model.postImageData = nil
                }
              } label: {
                Image(systemName: "trash")
                  .fontWeight(.bold)
                  .tint(.white)
              }
              .padding()
            }
            // Username on top left corner of the image selected.
            .overlay(alignment: .topLeading) {
              Text(userSelected?.userName.uppercased() ?? "")
                .font(.title)
                .fontWeight(.black)
                .padding(12)
            }
        }
        .clipped()
        .frame(height: 450)
        .padding()
        
        // Post Button
        Button {
          if (userSelected != nil) {
            model.makePost(for: userSelected!, by: myUserData.myUserProfile!)
            showMakePostView = false
          }
        } label: {
          Text("Post")
        }
      } // [End of if statement]
    }
  }
  
  // fetch users for the search functionality. Fetches those users that have the keyword that you type in the search bar in their userName and Full Name.
  private func fetchUsers(containing keyword: String) {
    let db = FirebaseManager.shared.firestore
    db.collection("Users").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in
      guard let documents = querySnapshot?.documents, error == nil else { return }
      
      // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
      userQueries = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: User.self)
      }
      
    }
  } // End of method fetchUsers()
}

struct FeedViewPostView_Previews: PreviewProvider {
  static var previews: some View {
    FeedViewPostView(model: FeedViewModel(), showMakePostView: .constant(true))
  }
}
