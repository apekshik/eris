//
//  KeyboardHeightHelper.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/8/23.
//

import UIKit
import Foundation

class KeyboardHeightHelper: ObservableObject {
  
  @Published var keyboardHeight: CGFloat = 0
  
  init() {
      self.listenForKeyboardNotifications()
  }
  
  private func listenForKeyboardNotifications() {
    NotificationCenter
      .default
      .addObserver(forName: UIResponder.keyboardWillShowNotification,
                   object: nil,
                   queue: .main) { (notification) in
        guard let userInfo = notification.userInfo,
              let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
          self.keyboardHeight = keyboardRect.height
      }

    NotificationCenter
      .default
      .addObserver(forName: UIResponder.keyboardWillHideNotification,
                                           object: nil,
                                           queue: .main) { (notification) in
      self.keyboardHeight = 0
    }
  }
}
