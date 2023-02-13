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
  
  var body: some View {
    NavigationStack {
      ZStack {
        GradientBackgroundFeed()
          .opacity(0.6)
        ScrollView {
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
 
          ForEach(0..<30) { _ in
            Rectangle()
              .fill(.ultraThinMaterial)
              .frame(maxWidth: .infinity, minHeight: 200)
              .cornerRadius(10)
              .padding()
          }
          .onChange(of: model.postImageData) { newValue in
            if newValue != nil {
              showMakePostView.toggle()
            }
          }
        }
        .searchable(text: $textInput, placement: .navigationBarDrawer)
      }
      .toolbarBackground(.hidden, for: .navigationBar)
    }
    .task {
      model.myData = myUserData.myUserProfile
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
}

struct NewFeedView_Previews: PreviewProvider {
  static var previews: some View {
    NewFeedView()
  }
}
