//
//  CameraView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//
//  Learnt this from YT Tutorial - https://www.youtube.com/watch?v=ZmPJBiwgZoQ
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI
import AVFoundation

struct LegacyCameraView: UIViewControllerRepresentable {
  
  typealias UIViewControllerType = UIViewController
  
  let cameraService: LegacyCameraService
  let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
  
  
  func makeUIViewController(context: Context) -> UIViewController {
    
    cameraService.start(delegate: context.coordinator) { err in
      if let err = err {
        didFinishProcessingPhoto(.failure(err))
        return
      }
    }
    
    let viewController = UIViewController()
    viewController.view.backgroundColor = .black
    viewController.view.layer.addSublayer(cameraService.previewLayer)
    cameraService.previewLayer.frame = viewController.view.bounds
    return viewController
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
  }
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
  
  class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
    let parent: LegacyCameraView
    private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    init(_ parent: LegacyCameraView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()) {
      self.parent = parent
      self.didFinishProcessingPhoto = didFinishProcessingPhoto
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      if let error = error {
        didFinishProcessingPhoto(.failure(error))
        return
      }
      didFinishProcessingPhoto(.success(photo))
    }
  }
}
