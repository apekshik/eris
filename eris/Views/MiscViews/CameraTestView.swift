//
//  CameraTestView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct CameraTestView: View {
  @State private var capturedImage: UIImage? = nil
  @State private var isCustomCameraViewPresented: Bool = false
    var body: some View {
      ZStack {
        if capturedImage != nil {
          Image(uiImage: capturedImage!)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        } else {
          Color(UIColor.systemBackground)
        }
        VStack {
          Spacer()
          
          Button {
            // action
            isCustomCameraViewPresented.toggle()
          } label: {
            Image(systemName: "camera.fill")
              .font(.largeTitle)
              .padding()
              .background(.black)
              .foregroundColor(.white)
              .clipShape(Circle())
          }
          .padding(.bottom)
          .fullScreenCover(isPresented: $isCustomCameraViewPresented) {
            LegacyCustomCameraView(capturedImage: $capturedImage)
          }
        }
      }
    }
}

struct CameraTestView_Previews: PreviewProvider {
    static var previews: some View {
        CameraTestView()
    }
}
