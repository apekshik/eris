//
//  NewFeedView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/9/23.
//

import SwiftUI

struct NewFeedView: View {
  @State var textInput: String = ""
  @State var showCamera: Bool = false
  @StateObject var model: FeedViewModel = FeedViewModel()
  @EnvironmentObject var myUserData: MyData
  
  
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
          
          
          if let postImageData = model.postImageData, let image = UIImage(data: postImageData) {
            VStack {
              GeometryReader { proxy in
                let size = proxy.size
                Image(uiImage: image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: size.width, height: size.height)
                  .cornerRadius(5)
                  
                /// – Delete Button
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
              }
              .clipped()
              .frame(height: 350)
              .padding()
              
              // Post Button
              Button {
                model.makePost()
              } label: {
                Text("Post")
              }
            }
          }
          
          ForEach(0..<30) { _ in
            Rectangle()
              .fill(.ultraThinMaterial)
              .frame(maxWidth: .infinity, minHeight: 200)
              .cornerRadius(10)
              .padding()
          }
        }
        .searchable(text: $textInput, placement: .navigationBarDrawer)
        
       
//        .background(.blue)
        
      }
      .toolbarBackground(.hidden, for: .navigationBar)
    }
    .sheet(isPresented: $showCamera, content: {
      CameraView(showCameraView: $showCamera)
    })
    .photosPicker(isPresented: $model.showPhotoPicker, selection: $model.photoItem)
    .onChange(of: model.photoItem) { newValue in
      model.updatePhoto(selectedPhotoPickerItem: newValue)
    }
    .overlay {
      LoadingView(show: $model.isLoading)
    }
    .onAppear {
      Task { await model.fetchUsersIFollow() }
    }
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
