//
//  CameraView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
  
  typealias UIViewControllerType = UIViewController
  
  let cameraService: CameraService
  let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
  
  
  func makeUIViewController(context: Context) -> UIViewController {
    let viewController = UIViewController()
    return viewController
  }
  
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
