//
//  NewProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/4/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct NewProfileView: View {
  @State var profilePictureEnlarge: Bool = false
  @Namespace var namespace
  
  @State var boujees: [LivePost] = []
  @State var addBoujee: Bool = false
  @State private var listener: ListenerRegistration?
  @State private var scrollProxy: ScrollViewProxy? = nil
  @State var showLivePostTutorialCard: Bool = false
  
  var body: some View {
    ZStack {
      VStack {
        Spacer()
          .frame(height: profilePictureEnlarge ? 450 : 70)
        livePostView
          .frame(maxHeight: .infinity, alignment: .top)
      }
      
//      header
    }
  }
  
  var header: some View {
    VStack(spacing: 0) {
      ZStack {
        Rectangle()
          .fill(.gray)
          .frame(maxWidth: .infinity, maxHeight: 100)
          .blur(radius: 40)
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
      Text("BillBoard".uppercased())
        .font(.title)
        .fontWeight(.bold)
    }
//    .frame(maxHeight: .infinity, alignment: .top)
//    .offset(x: profilePictureEnlarge ? 10 : 0, y: profilePictureEnlarge ? -90 : 0)
  }
  
  var livePostView: some View {
    // VStack for Body of LivePostView and PostField Footer.
    ZStack {
      
      livePostContent
    }
    
  }
  
  var livePostContent: some View {
    VStack {
      // ScrollView for all LivePosts.
      ScrollView(.vertical, showsIndicators: false) {
        
          ScrollViewReader { proxy in
            LazyVStack(alignment: .leading, spacing: 4) {
              ForEach(boujees, id: \.self) { boujee in
                GeometryReader { geo in
//                  let midY = geo.frame(in: .global).midY
//                  let minX = geo.frame(in: .global).minX
//                  let minY = geo.frame(in: .global).minY
//                  let lmidX = geo.frame(in: .local).midX
//                  let lmidY = geo.frame(in: .local).midY
                  Text("**\(boujee.anonymous ? "anon".uppercased() : boujee.authorUsername.lowercased())** \(boujee.text)")
//                    .frame(width: geo.size.width, height: geo.size.height)
//                    .padding(8)
//                    .lineLimit(3)
                    .font(.title2)
                    .id(boujee.id) // this is crucial for the scrollViewReader Proxy to function properly.
                    
//                    .blur(radius: abs(midY) / 70)
                }
              } // End of ForEach
              .onAppear {
                scrollProxy = proxy
                // In the beginning scroll to bottom without animation.
                scrollProxy?.scrollTo(boujees.last?.id)
              }
            } // [LazyVStack End]
          } // [ScrollViewReader End]
      }
//      .padding(8)
      .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
      .onChange(of: boujees) { _ in
        scrollToBottom()
      }
    }
  }
  private func scrollToBottom() {
      withAnimation {
          scrollProxy?.scrollTo(boujees.last?.id, anchor: .bottom)
      }
  }
}

struct NewProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NewProfileView(boujees: exampleLivePosts)
  }
}
