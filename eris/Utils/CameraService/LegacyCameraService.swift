//
//  CameraService.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/28/23.
//
//  From Tutorial on YT - https://www.youtube.com/watch?v=ZmPJBiwgZoQ
//  Modified by Apekshik Panigrahi on 01/29/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com). All rights reserved.
//  Proprietary Software License
//

import Foundation
import AVFoundation

class LegacyCameraService {

  var session: AVCaptureSession?
  var delegate: AVCapturePhotoCaptureDelegate?
  
  let output = AVCapturePhotoOutput()
  let previewLayer = AVCaptureVideoPreviewLayer()
  
  func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
    self.delegate = delegate
    checkPermissions(completion: completion)
  }
  
  private func checkPermissions(completion: @escaping (Error?) -> ()) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
      
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        guard granted else { return }
        DispatchQueue.main.async {
          self?.setupCamera(completion: completion)
        }
      }
    case .restricted:
      break
    case .denied:
      break
    case .authorized:
      setupCamera(completion: completion)
    @unknown default:
      break
    }
  }
  
  private func setupCamera(completion: @escaping (Error?) -> ()) {
    let session = AVCaptureSession()
    if let device = AVCaptureDevice.default(for: .video) {
      do {
        let input = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(input) {
          session.addInput(input)
        }
        
        if session.canAddOutput(output) {
          session.addOutput(output)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = session
        
        session.startRunning()
        self.session = session
      } catch {
        
      }
    }
  } // End of setupCamera() function
  
  func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
    output.capturePhoto(with: settings, delegate: delegate!)
  }
  
}
