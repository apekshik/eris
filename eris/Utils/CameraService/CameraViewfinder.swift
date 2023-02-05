//
//  CameraPreview.swift
//  SwiftCamera
//
//  Created by Rolando Rodriguez on 10/17/20.
//
//  Under MIT License
//  Source: https://github.com/rorodriguez116/SwiftCamera.git
//
//  Modified by Apekshik Panigrahi on 01/29/23
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com). All rights reserved.
//  Proprietary Software License
//

import SwiftUI
import AVFoundation

struct CameraViewfinder: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait

        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
      
    }
}

struct CameraViewfinder_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewfinder(session: AVCaptureSession())
            .frame(height: 300)
    }
}
