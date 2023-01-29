//
//  OnboardingView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/7/23.
//  Copyright © 2023 Apekshik Panigrahi (apekshik@gmail.com)
//  Proprietary Software License
//

import SwiftUI

struct OnboardingView: View {
  @Binding var showOnboardingView: Bool
  var body: some View {
    TabView {
      firstView
      
      secondView
      
      thirdView
    }
    .tabViewStyle(.page(indexDisplayMode: .never))

  }
  
  var firstView: some View {
    VStack(spacing: 12) {
      
      Text("BOUJÈ")
        .font(.system(.largeTitle))
        .fontWeight(.heavy)
        .fontDesign(.serif)
      
      
      HStack {
        Text("Don't worry, we're not going to bore you with long explanations on what exactly is **BOUJÈ**, or how you'd navigate your way through our app. However, a quick overview will get you upto speed with most of our features. We believe you're smart enough to figure out the rest :) ")
//          .fontWeight(.semibold)
          .font(.title3)
          .fontDesign(.rounded)
          .frame(width: 320)
          .padding()
        Spacer()
      }
      
      HStack {
        Spacer()
        Text("Most social media apps today are about self-expression. You go out there and post about **your** experiences and memories to your friends and followers. BOUJÈ takes that concept and flips it on its head.  ")
          .multilineTextAlignment(.trailing)
//          .fontWeight(.semibold)
          .font(.title3)
          .fontDesign(.rounded)
          .frame(width: 320)
          .padding()
      }
      
      Image("onb1")
        .resizable()
        .scaledToFit()
        .cornerRadius(10)
        .padding()
      
      HStack {
        Text("Swipe".uppercased())
        Image(systemName: "arrow.right")
          .resizable()
          .frame(width: 15, height: 15)
      }
    }
    
  }
  
  var secondView: some View {
    VStack(spacing: 0) {
      
      Text("BOUJÈ")
        .font(.system(.largeTitle))
        .fontWeight(.heavy)
        .fontDesign(.serif)
      
      HStack {
        Text("Our app is structured in such a manner that you can only post for the people you follow. We call these posts **\"Boujees\"**. BOUJÈ is a place where you Boujee other people, but never yourself (you can't). This means you'll be boujee'd by your followers and friends. ")
//          .fontWeight(.semibold)
          .font(.title3)
          .fontDesign(.rounded)
          
          .padding()
        Spacer()
      }
      
      HStack {
        Spacer()
        Text("So, to put it simply, our app isn't a place of self-expression, but rather self-reflection and self-observation. Okay, we're getting way too philosophical for a social media app now.")
          .multilineTextAlignment(.trailing)
//          .fontWeight(.semibold)
          .font(.title3)
          .fontDesign(.rounded)
          .frame(width: 340)
          .padding()
      }
      
      HStack {
        Text("The point is, we're trying to create an interesting environment where people share far more about each other than themselves.")
          .font(.title3)
          .fontDesign(.rounded)
          .frame(width: 350)
          .padding()
        Spacer()
      }
      
      Text("So share, explore and have fun!".uppercased())
        .font(.caption)
        .fontWeight(.black)
        .padding()
      
      Image("onb2")
        .resizable()
        .scaledToFit()
        .cornerRadius(10)
        .padding()
      
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
  
  var thirdView: some View {
    VStack {
      VStack(spacing: 8){
        Text("BOUJÈ")
          .font(.system(.largeTitle))
          .fontWeight(.heavy)
          .fontDesign(.serif)
        
        VStack {
          Text("Created by".uppercased())
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
      
      Image("onb3")
        .resizable()
        .scaledToFit()
        .cornerRadius(10)
        .padding()
        
      Text("Alright, can I start using the app now?")
        .font(.title3)
        .fontWeight(.black)
        .padding()
      
      Button{
        showOnboardingView = false
      } label: {
        Text("Enter BOUJÈ".uppercased())
          .padding([.horizontal])
          .padding([.vertical], 8)
          .foregroundColor(.black)
          .background(.white)
          .cornerRadius(5)
      }
      
      Spacer()
      
      // Copyright Notice Footer
      VStack {
        Text("Copyright © 2023 Apekshik Panigrahi.")
          .font(.footnote)
        Text("All Rights Reserved.")
          .font(.footnote)
      }
    }
    .frame(maxHeight: .infinity)
    .ignoresSafeArea()
    
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(showOnboardingView: .constant(true))
  }
}
