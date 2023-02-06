//
//  GeoReaderTest.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/5/23.
//

import SwiftUI

struct GeoReaderTest: View {
  @State var profilePictureEnlarge: Bool = false
  @State var showLiveTutorial: Bool = false
  @Namespace var namespace
  func getPercentage(geo: GeometryProxy) -> Double {
    let maxDistance = UIScreen.main.bounds.height / 2
    let currentY = geo.frame(in: .global).midY
    return Double(1 - (currentY / maxDistance))
  }
  
  var body: some View {
    NavigationStack {
      ZStack {
        NewGradientBackground()
          .opacity(0.3)
        VStack {
          Spacer()
            .frame(height: profilePictureEnlarge ? 390 : 0)
          textContent
        }
        
        header
        
        LivePostTutorialView(show: $showLiveTutorial)
      }
      .toolbarBackground(.hidden, for: .tabBar)
    }
  }
  
  var textContent: some View {
    ScrollView {
      LazyVStack {
        ForEach(0..<40) { index in
          GeometryReader { geo in
            let midY = geo.frame(in: .named("scrollView")).midY
            ZStack {
//              RoundedRectangle(cornerRadius: 10)
//                .fill(.orange)
//                .blur(radius: getPercentage(geo: geo))
              Text("Here's some Test code to blur and see how it goes. So let's say I ")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .blur(radius: 30 * (1 - (midY / 150)))
            }
            .padding(.horizontal, 20)
            .opacity(midY / 150 > 1 ? 1 : midY / 150)
          }
          .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 400)
        }
      }
      .onTapGesture {
        if profilePictureEnlarge {
          withAnimation(.spring()) {
            profilePictureEnlarge.toggle()
          }
        }
      }
    }
    .coordinateSpace(name: "scrollView")
  }
  
  var header: some View {
    VStack(spacing: 0) {
      ZStack {
        VStack {
          if profilePictureEnlarge {
            profilePictureLarge
              .onTapGesture {
                withAnimation(.spring(blendDuration: 25)) {
                  profilePictureEnlarge.toggle()
                }
              }
          }
          HStack {
            if !profilePictureEnlarge {
              profilePictureSmall
                .onTapGesture {
                  withAnimation(.spring()) {
                    profilePictureEnlarge.toggle()
                  }
                }
            }
            
            profileData
            Spacer()
            VStack {
              Image(systemName: "capsule.portrait.inset.filled")
                .resizable()
                .frame(width: 20, height: 30)
                
              
              Text("Following")
            }
            .padding([.trailing])
          }
          .frame(maxWidth: .infinity, alignment: .topLeading)
        }
       
      }
      Spacer()
    }
    .padding()
    
  }
  
  var profilePictureLarge: some View {
    GeometryReader { proxy in
      let size = proxy.size
      Image("Mad1Large")
        .resizable()
        .scaledToFill()
        .frame(width: size.width, height: size.height)
    }
    .clipped()
    .matchedGeometryEffect(id: "profilePic", in: namespace)
    .frame(maxWidth: .infinity, maxHeight: 400)
    .cornerRadius(5)
//    .frame(maxHeight: .infinity, alignment: .top)
  }
  
  var profilePictureSmall: some View {
    GeometryReader { proxy in
      let size = proxy.size
      Image("Mad1Large")
        .resizable()
        .scaledToFill()
        .frame(width: size.width, height: size.height)
    }
    
    .clipped()
    .matchedGeometryEffect(id: "profilePic", in: namespace)
    .frame(width: 70, height: 70)
    .cornerRadius(5)

//    .frame(maxHeight: .infinity, alignment: .top)
  }
  
  var profileData: some View {
    VStack(alignment: .leading) {
      Text("Madhan Mohan".uppercased())
        .fontWeight(.heavy)
      Text("@madhansolo")
        .font(.subheadline)
        .foregroundColor(.secondary)
      Button {
        showLiveTutorial.toggle()
      } label: {
        Text("BillBoard".uppercased())
          .font(.title)
          .fontWeight(.bold)
          .tint(.white)
      }
    }
//    .frame(maxHeight: .infinity, alignment: .top)
//    .offset(x: profilePictureEnlarge ? 10 : 0, y: profilePictureEnlarge ? -90 : 0)
  }
  
}

struct GeoReaderTest_Previews: PreviewProvider {
  static var previews: some View {
    GeoReaderTest()
  }
}
