//
//  ReviewForm.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/7/22.
//

import SwiftUI

struct ReviewForm: View {
  @State private var relation: String = ""
  @State private var threeWords: String = ""
  @State private var comment: String = ""
  var body: some View {
    VStack {
      Image(systemName: "photo.circle")
        .resizable()
        .frame(maxWidth: 100, maxHeight: 100)
      Text("Reviewing Apekshik")
        .font(.system(size: 26))
      Form {
        Section(header: Text("Personal Information")) {
          Text("Who are you to Apekshik?")
          TextField("Friend, Co-Worker, Ex-,...", text: $relation)
          Text("What 3 words best describe him?")
          TextField("Three words or phrases...", text: $threeWords)
        }
        Section(header: Text("Comments")) {
          Text("Anything specific you'd like to mention about him?")
          TextField("Type here", text: $comment)
          
        }
        
        Button("Submit Review") {
          
        }
        .frame(maxWidth: .infinity, alignment: .center)
      }
    }
  }
}

struct ReviewForm_Previews: PreviewProvider {
  static var previews: some View {
    ReviewForm()
  }
}
