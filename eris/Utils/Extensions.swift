//
//  Extensions.swift
//
//
//  Created by Apekshik Panigrahi on 5/31/22.
//

import SwiftUI
import Combine
import UIKit

// MARK: UI View Building Extensions
extension View {
  // adding a cornerRadius to specific corners of your rectangle View.
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
  
  // It's the same as adding these frame modifiers directly to the views.
  func hAlign(_ alignment: Alignment) -> some View {
    self
      .frame(maxWidth: .infinity, alignment: alignment)
  }
  
  func vAlign(_ alignment: Alignment) -> some View {
    self
      .frame(maxHeight: .infinity, alignment: alignment)
  }

  func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  // When called inside .onTapGesture, tapping anywhere on the view dismissed the keyboard.
  func hideKeyboardOnTap() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
  
  
}



// Needed for cornerRadius View Extension
struct RoundedCorner: Shape {
  
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

// Got this from https://gist.github.com/kunikullaya/6474fc6537ed616b1c617646d263555d
// But also changed descending components to KeyValuePairs (since regular dicts in swift aren't ordered).
extension Date {
  func time(since fromDate: Date) -> String {
    let earliest = self < fromDate ? self : fromDate
    let latest = (earliest == self) ? fromDate : self
    
    let allComponents: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let components:DateComponents = Calendar.current.dateComponents(allComponents, from: earliest, to: latest)
    let year = components.year  ?? 0
    let month = components.month  ?? 0
    let week = components.weekOfYear  ?? 0
    let day = components.day ?? 0
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    let descendingComponents: KeyValuePairs = ["year": year, "mth": month, "week": week, "day": day, "hour": hour, "min": minute, "second": second]
    for (period, timeAgo) in descendingComponents {
      if timeAgo > 0 {
        return "\(timeAgo.of(period)) ago"
      }
    }
    
    return "Just now"
  }
}

extension Int {
  func of(_ name: String) -> String {
    guard self != 1 else { return "\(self) \(name)" }
    return "\(self) \(name)s"
  }
}


extension String {
  func widthOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
  
  func heightOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.height
  }
}

/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
