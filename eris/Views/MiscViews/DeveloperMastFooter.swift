//
//  DeveloperMastFooter.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/22/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct DeveloperMastFooter: View {
    var body: some View {
      VStack {
        Text("Developed by".uppercased())
          .font(.caption2)
          .fontWeight(.semibold)
          .fontDesign(.rounded)
          .foregroundColor(.secondary)
        Text("Apekshik Panigrahi".uppercased())
          .font(.caption)
          .fontWeight(.semibold)
          .fontDesign(.rounded)
      }
    }
}

struct DeveloperMastFooter_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperMastFooter()
    }
}
