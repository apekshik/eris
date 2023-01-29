//
//  Test2View.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/18/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct Test2View: View {
  var body: some View {
    test
    
  }
  
  var test: some View {
    NavigationStack {
      ScrollView {
        VStack {
          Text("Hello World")
        }
        
      }
      .background(bg)
    }
  }
  
  var bg: some View {
    VStack {
      Text("Test")
    }
    .background(.blue)
  }
}

struct Test2View_Previews: PreviewProvider {
  static var previews: some View {
    Test2View()
  }
}
