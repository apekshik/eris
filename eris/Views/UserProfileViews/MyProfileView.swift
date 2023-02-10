//
//  GeoReaderTest.swift
//  eris
//
//  Created by Apekshik Panigrahi on 2/5/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MyProfileView: View, KeyboardReadable {
  @State var profilePictureEnlarge: Bool = false
  @State var showLiveTutorial: Bool = false
  @State var textInput: String = ""
  @Namespace var namespace
  
  // State variables from LegacyPostView
  // user is the current user logged in.
  @State var user: User = exampleUsers[0]
  @State var boujees: [LivePost] = []
  @State var addBoujee: Bool = false
  @State private var listener: ListenerRegistration?
  @State private var scrollProxy: ScrollViewProxy? = nil
  
  // states for adding a new live post. 
  @State var newContent: String = ""
  //  @State var forUser: User? = nil
  @State var author: User? = nil
  @State var anonymous: Bool = false
  
  // keyboard hiding/unhiding controls for views to move up and down accordingly.
  @State var isKeyboardVisible: Bool = false
  @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
  
  var body: some View {
    
      ZStack {
        NewGradientBackground()
          .opacity(0.3)
        
        Group {
          VStack {
            Spacer()
              .frame(height: profilePictureEnlarge ? 390 : 0)
            textContent
          }
          header
        }
        .offset(y: isKeyboardVisible ? -self.keyboardHeightHelper.keyboardHeight + 40 : 0)
        
        LivePostTutorialView(show: $showLiveTutorial)
      }
//      .onAppear {
//        startListeningBoujees()
//      }
//      .onDisappear {
//        stopListeningBoujees()
//      }
  }

  // [COMPONENTS FOR THE BODY START HERE]
  var textContent: some View {
    ScrollView {
      ScrollViewReader { proxy in
        LazyVStack {
          ForEach(boujees, id: \.self) { boujee in
            // calculate render width and height of text using provided font (without actually rendering)
            let height: CGFloat = boujee.text.heightOfString(usingFont: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy))
            let totalWidth: CGFloat = boujee.text.widthOfString(usingFont: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy))
            let numberOfLines = ceil(totalWidth / (UIScreen.main.bounds.width))
            let screenHeight = UIScreen.main.bounds.height
            let blurHeight: CGFloat = 130
            let blurHeightStart = screenHeight - blurHeight
            GeometryReader { geo in
              let minY = geo.frame(in: .named("scrollView")).minY
//              let maxY = geo.frame(in: .named("scrollView")).maxY
              VStack(alignment: .leading) {
                HStack(spacing: 0) {
                  Text("@\(boujee.anonymous ? "anon".uppercased() : boujee.authorUsername.lowercased()) ")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .opacity(0.8)
                  Text("• \(boujee.createdAt.time(since: Date()))")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .opacity(0.6)
                }
                Text("\(boujee.text)")
                  .font(.system(size: 24))
                  .fontWeight(.heavy)
              }
                .blur(radius: 30 * (1 - (minY / 80)))
                .blur(radius: (minY < blurHeightStart) ? 0 : 20 * (minY - blurHeightStart) / (blurHeight))
                .id(boujee.id)
                .padding(.horizontal, 20)
                .opacity(minY / 110 > 1 ? 1 : minY / 110)
            } // [End of GeometryReader]
            .frame(maxWidth: .infinity, minHeight: (height + 4) * (numberOfLines + 1))
          } // [End of ForEach]
          .onAppear {
            scrollProxy = proxy
            // In the beginning scroll to bottom without animation.
            scrollProxy?.scrollTo(boujees.last?.id)
          }
        } // [End of LazyVStack]
        .onTapGesture {
          if profilePictureEnlarge {
            withAnimation(.spring()) {
              profilePictureEnlarge.toggle()
            }
          }
          hideKeyboardOnTap()
        }
      }
    }
    .onChange(of: boujees) { _ in
      scrollToBottom()
    }
    .safeAreaInset(edge: .bottom) {
      inputField
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
          withAnimation(.spring()) {
            isKeyboardVisible = newIsKeyboardVisible
          }
        }
        .offset(x: 0, y: profilePictureEnlarge ? 150 : 0)
        
    }
    .safeAreaInset(edge: .top) {
      Rectangle()
        .fill(.clear)
        .frame(width: .infinity, height: 100)
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
  
  var inputField: some View {
    HStack {
      TextField("Type here...", text: $textInput, axis: .vertical)
        
      Button {
        
      } label: {
        Image(systemName: "paperplane.circle")
          .resizable()
          .frame(width: 25, height: 25)
          .tint(.white)
      }
    }
    .padding()
    .background(.ultraThinMaterial)
    .cornerRadius(10)
    .padding()
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
  
  var profilePictureLarge: some View {
    GeometryReader { proxy in
      let size = proxy.size
      Image("Joji1")
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
      Image("Joji1")
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
      Text("George Miller".uppercased())
        .fontWeight(.heavy)
      Text("@joji")
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
  
  private func startListeningBoujees() {
    let db = FirebaseManager.shared.firestore
    let secondsInADay: Double = 60 * 60 * 24
    listener = db.collection("LiveBoujees")
      .whereField("userID", isEqualTo: user.firestoreID)
      .whereField("createdAt", isGreaterThanOrEqualTo: Date(timeIntervalSinceNow: -secondsInADay))
      .order(by: "createdAt")
      .addSnapshotListener { querySnapshot, error in
        guard let documents = querySnapshot?.documents else {
          print("Error fetching documents from LiveBoujees")
          return
        }
        
        boujees = documents.compactMap({ queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: LivePost.self)
        })
      }
  }
  
  private func stopListeningBoujees() {
    listener?.remove()
  }
  
  private func scrollToBottom() {
      withAnimation {
          scrollProxy?.scrollTo(boujees.last?.id, anchor: .bottom)
      }
  }
  
  // post comment to firestore and empties textfield string.
  private func postBoujee() async {
    Task {
      do {
        // in the case that some bombaclut tries to post an empty comment.
        guard newContent.count > 0 else { return }
        
        // Populates the author variable.
        await fetchMyData()
        
        let db = FirebaseManager.shared.firestore
        let newBoujeeRef = db.collection("LiveBoujees").document()
        // We can use the bang (!) operator on the author var becauase we know we fetched the data and then tried to create a new Comment Instance.
        let newBoujee = LivePost(userID: user.firestoreID, authorID: author!.firestoreID, selfID: newBoujeeRef.documentID, createdAt: Date(), text: newContent, authorUsername: author!.userName, recipientUsername: user.userName, anonymous: anonymous)
        
        
        try db.collection("LiveBoujees").document(newBoujeeRef.documentID).setData(from: newBoujee)
        
        await MainActor.run {
          newContent = ""
        }
      } catch {
        // do something about the errors.
      }
    }
  }
  
  // Fetch my User Data.
  private func fetchMyData() async {
      guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
      guard let user = try? await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self) else { return }
      
    await MainActor.run(body: {
        self.author = user
      })
  }
}

struct GeoReaderTest_Previews: PreviewProvider {
  static var previews: some View {
    MyProfileView(boujees: exampleLivePosts)
  }
}
