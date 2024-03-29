//
//  CameraView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/29/23.
//  Copyright © 2022 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI
import PhotosUI

struct CameraView: View {
  @EnvironmentObject var model: CameraViewModel
  
  @State var currentZoomFactor: CGFloat = 1.0
  @State var photoItem: PhotosPickerItem?
  @State var showPhotoPicker: Bool = false
  @Binding var showCameraView: Bool
  
  // MARK: [main body starts here]
  var body: some View {
    GeometryReader { reader in
      ZStack {
        // This black background lies behind everything. 
        Color.black.edgesIgnoringSafeArea(.all)
        
//        if showCameraView {
          CameraViewfinder(session: model.session)
            
  //          .gesture(
  //            DragGesture().onChanged({ (val) in
  //              //  Only accept vertical drag
  //              if abs(val.translation.height) > abs(val.translation.width) {
  //                //  Get the percentage of vertical screen space covered by drag
  //                let percentage: CGFloat = -(val.translation.height / reader.size.height)
  //                //  Calculate new zoom factor
  //                let calc = currentZoomFactor + percentage
  //                //  Limit zoom factor to a maximum of 5x and a minimum of 1x
  //                let zoomFactor: CGFloat = min(max(calc, 1), 5)
  //                //  Store the newly calculated zoom factor
  //                currentZoomFactor = zoomFactor
  //                //  Sets the zoom factor to the capture device session
  //                model.zoom(with: zoomFactor)
  //              }
  //            })
  //          )
            .onAppear {
              model.configure()
            }
            .alert(isPresented: $model.showAlertError, content: {
              Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                model.alertError.primaryAction?()
              }))
            })
            .overlay(
              Group {
                if model.willCapturePhoto {
                  Color.black
                }
              }
            )
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: reader.size.width,height: reader.size.height )
          //            .animation(.easeInOut)
        }
        
        VStack {
          HStack {
            closeButton
            
            Spacer()
            
            flashButton
          }
          
          HStack {
            capturedPhotoThumbnail
              .onTapGesture {
                showPhotoPicker.toggle()
              }
            
            Spacer()
            
            captureButton
            
            Spacer()
            
            flipCameraButton
            
          }
          .padding([.horizontal, .bottom], 20)
          .frame(maxHeight: .infinity, alignment: .bottom)
//        }
      } // [ZStack Ends Here]
    } // [Geometry Reader Ends here]
    .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem)
  } // [Main Body Ends here]
  
  // MARK: Components Necessary for body above.
  
  var closeButton: some View {
    Button {
      showCameraView.toggle()
    } label: {
      Image(systemName: "xmark")
        .resizable()
        .frame(width: 20, height: 20)
        .tint(.white)
    }
    .padding(24)
  }
  var flashButton: some View {
    // Button to toggle flashMode.
    Button {
      model.switchFlash()
    } label: {
      Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
        .font(.system(size: 20, weight: .medium, design: .default))
    }
    .accentColor(model.isFlashOn ? .yellow : .white)
    .padding(24)
  }
  
  var captureButton: some View {
    Button {
      model.capturePhoto()
      showCameraView.toggle()
    } label: {
      Image(systemName: "circle")
        .font(.system(size: 72))
        .foregroundColor(.white)
      //      Circle()
      //        .foregroundColor(.white)
      //        .frame(width: 80, height: 80, alignment: .center)
      //        .overlay(
      //          Circle()
      //            .stroke(Color.black.opacity(0.8), lineWidth: 2)
      //            .frame(width: 65, height: 65, alignment: .center)
      //        )
    }
  }
  
  var capturedPhotoThumbnail: some View {
    Group {
      if model.photo != nil {
        Image(uiImage: model.photo.image!)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 60, height: 60)
          .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        //          .animation(.spring())
        
      } else {
        RoundedRectangle(cornerRadius: 10)
          .frame(width: 60, height: 60, alignment: .center)
          .foregroundColor(.black)
      }
    }
  }
  
  var flipCameraButton: some View {
    Button {
      model.flipCamera()
    } label: {
      Circle()
        .foregroundColor(Color.gray.opacity(0.2))
        .frame(width: 45, height: 45, alignment: .center)
        .overlay(
          Image(systemName: "camera.rotate.fill")
            .foregroundColor(.white)
            .font(.system(size: 24))
        )
      
    }
  }
}

