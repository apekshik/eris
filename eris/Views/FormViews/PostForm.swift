//
//  ReviewForm.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/7/22.
//  Copyright © 2022 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import PhotosUI

struct PostForm: View {
  
  // Regular variables.
  private let ratings: [Int] = [0, 1, 2, 3, 4, 5]
  private let relations: [String] = ["Friend", "Ex-", "Co-worker"]
  
  // State variables.
  @State private var relation: String = ""
  @State private var comment: String = ""
  @State private var rating: Int = 0
  @State private var experienceWithThem: String = ""
  //  @State private var threeWords: String = ""
  
  // First name of the person who a review form is being created for.
  @State var user: User
  @Binding var show: Bool
  
  // PhotoPicker vars
  @State var showPhotoPicker: Bool = false
  @State var photoItem: PhotosPickerItem? = nil
  @State var postImageData: Data?
  
  @State var isLoading: Bool = false
  
  // Main UI View body.
  var body: some View {
    VStack(spacing: 12) {
      // Title and Image (placeholder image for now).
      //            Image(systemName: "photo.circle")
      //                .resizable()
      //                .frame(maxWidth: 90, maxHeight: 90)
      VStack(spacing: 20) {
        Button {
          show = false
        } label: {
          Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 35, height: 35)
            .tint(.black)
        }
        Text("Fill Boujee".uppercased())
          .font(.title)
          .fontWeight(.bold)
          .opacity(0.75)
      }
      
      
      // Form starts here.
      Form {
        
        // Personal information
        Section(header: Text("Personal Information")) {
          //          TextField("Friend, Co-Worker, Ex-,...", text: $relation)
          Picker("Who are you to \(user.firstName)?", selection: $relation) {
            ForEach(relations, id: \.self) { rel in
              Text(String(rel))
            }
          }
        }
        
        // Comments section.
        Section("Comments and Pictures") {
          TextField("Type here", text: $comment, axis: .vertical)
            .lineLimit(3, reservesSpace: true)
          
          //          // One word description
          //          Text("Now, a word that describes your experience with them")
          //          TextField("One word please :)", text: $experienceWithThem)
          
          // Ratings picker
          Picker("An overall rating for this person :)", selection: $rating) {
            ForEach(ratings, id: \.self) { rating in
              Text(String(rating))
            }
          }
          
          // Image Picker
          Button {
            showPhotoPicker = true
          } label: {
            HStack {
              Text("Add Photos")
              Image(systemName: "photo.on.rectangle.angled")
            }
          }
          
          if let postImageData, let image = UIImage(data: postImageData) {
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
                      self.postImageData = nil
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
            .frame(height: 250)
          }
        } // End of Comments Section
        
        // Submit button
        Button("Post Boujee".uppercased()) {
          // TODO: handle errors properly.
          handleFormSubmit()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(.black)
      } // End of Form.
      .frame(maxHeight: 610)
      .cornerRadius(10)
      .shadow(radius: 5)
    } // End of VStack
    .padding()
    .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem)
    .onChange(of: photoItem) { newValue in
      if let newValue {
        Task {
          if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
            
            await MainActor.run(body: {
              postImageData = compressedImageData
              photoItem = nil
            })
          }
        }
      }
    }
    .overlay {
      LoadingView(show: $isLoading)
    }
    
    
  } // End of main UI view body
  
  // TODO: convert this to throwable function with proper error handling.
  /// takes all the data user submitted, puts in the ReviewModel, encodes it and
  /// sends it out to the firestore database.
  private func handleFormSubmit() {
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
        let documentReference = db.collection("Reviews").document()
        
        /// Step 1:  Upload image if any.
        let imageReferenceID = "\(userID)\(documentReference.documentID)\(Date())"
        let storageRef = FirebaseManager.shared.storage.reference().child("PostImages").child(imageReferenceID)
        
        if let postImageData {
          
          let _ = try await storageRef.putDataAsync(postImageData)
          let downloadURL = try await storageRef.downloadURL()
          
          let newReview = Post(authorUserID: userID, authorUsername: "", recipientUserID: "", recipientUsername: "", imageURL: downloadURL, caption: "", isParent: true, isConnected: false, hasChain: false, connectedPostID: "", connectedPostImageURL: nil, connectedPostCaption: "", createdAt: Date())
          /// After uploading image to storage, upload document for new review to firestore.
          try documentReference.setData(from: newReview)
        } else {
          /// Else just upload a document to firestore.
          // create a new Review object with no image.
          let newReview = Post(authorUserID: userID, authorUsername: "", recipientUserID: "", recipientUsername: "", imageURL: nil, caption: "", isParent: true, isConnected: false, hasChain: false, connectedPostID: "", connectedPostImageURL: nil, connectedPostCaption: "", createdAt: Date())
          
          // finally post the data for the review to firestore.
          try documentReference.setData(from: newReview)
        }
        isLoading = false
        show = false
      } catch {
        // Catch and handle errors.
      }
    }
  }
}

struct ReviewForm_Previews: PreviewProvider {
  static var previews: some View {
    PostForm(user: exampleUsers[0], show: .constant(true))
  }
}
