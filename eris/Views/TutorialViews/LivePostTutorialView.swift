//
//  LivePostTutorialView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/13/23.
//

import SwiftUI

struct LivePostTutorialView: View {
  @Binding var show: Bool
  var body: some View {
    if show {
      fullBody
    }
  }
  
  var fullBody: some View {
    VStack(spacing: 20) {
      Button {
        show = false
      } label: {
        Image(systemName: "xmark.circle.fill")
          .resizable()
          .frame(width: 26, height: 26)
          .tint(.black)
      }
      
      Text("Introducing Live Boujees on this Update!")
        .fontWeight(.bold)
        .font(.headline)
      VStack(spacing: 12){
        Text("What is this you ask?")
          .fontWeight(.heavy)
          .foregroundColor(.secondary)
        Text("Well think of it as a permanent billboard that stays on your profile. It's a place where your friends and followers can post a few lines of text that dissappear after 24 hours. Kind of like instagram stories or snapchat snaps, but again, instead of **YOU** posting on here, it'll primarily be the people you're close with ;)")
          .font(.body)
        
        Text("Ohh, and you can definitely respond to them by posting a chat response for everyoen to see. The same goes for your followers' profiles. They all have their own live boujee \'BillBoards\' where you can head to and post :) ")
          .font(.body)
      }
      
      Text("So, happy boujeeing!!".uppercased())
        .fontWeight(.heavy)
      
      
      VStack {
        Text("Developed By".uppercased())
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
    .padding()
    .background(Color(hex: "edeff2"))
    .cornerRadius(10)
    .shadow(radius: 10)
    .padding()
  }
}

struct LivePostTutorialView_Previews: PreviewProvider {
  static var previews: some View {
    LivePostTutorialView(show: .constant(true))
  }
}
