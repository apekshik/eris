//
//  CustomCameraView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//

import SwiftUI

struct CustomCameraView: View {
  
  let cameraService = CameraService()
  
  @Binding var capturedImage: UIImage?
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    ZStack {
      CameraView(cameraService: cameraService) { result in
        switch result {
          
        case .success(let photo):
          if let data = photo.fileDataRepresentation() {
            capturedImage = UIImage(data: data)
            presentationMode.wrappedValue.dismiss()
          } else {
            print("Error: No Image data found")
          }
        case .failure(let err):
          print(err.localizedDescription)
        }
      }
      
      VStack { // VStack for Button to capture a picture when clicked.
        Spacer()
        
        Button {
          cameraService.capturePhoto()
        } label: {
          Image(systemName: "circle")
            .font(.system(size: 72))
            .foregroundColor(.white)
        }
        .padding(.bottom, 36)
      }
    }
    .ignoresSafeArea()
  }
}
