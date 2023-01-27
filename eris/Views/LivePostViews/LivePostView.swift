//
//  ProfileStoryView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/29/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LivePostView: View {
  @State var user: User
  @State var boujees: [LivePost] = []
  @State var addBoujee: Bool = false
  @State private var listener: ListenerRegistration?
  @State private var scrollProxy: ScrollViewProxy? = nil
  @State var showLivePostTutorialCard: Bool = false
  
  var body: some View {
    VStack {
      HStack {
        Text("BillBoard".uppercased())
          .font(.headline)
          .fontWeight(.heavy)
          .foregroundColor(.primary)
        Spacer()
        Button {
          showLivePostTutorialCard = true
        } label: {
          Image(systemName: "questionmark.circle.fill")
            .resizable()
            .frame(width: 20, height: 20)
            .shadow(radius: 4)
            .tint(.white)
        }
      }
      
      // VStack for Body of LivePostView and PostField Footer.
      VStack {
        // ScrollView for all LivePosts.
        ScrollView(.vertical, showsIndicators: false) {
          ScrollViewReader { proxy in
            LazyVStack(alignment: .leading, spacing: 4) {
              ForEach(boujees, id: \.self) { boujee in
                Text("**\(boujee.anonymous ? "anon".uppercased() : boujee.authorUsername.lowercased())** \(boujee.text)")
                  .font(.caption)
                  .id(boujee.id) // this is crucial for the scrollViewReader Proxy to function properly.
              } // End of ForEach
              .onAppear {
                scrollProxy = proxy
                // In the beginning scroll to bottom without animation.
                scrollProxy?.scrollTo(boujees.last?.id)
              }
            }
          }
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 270)
        .onChange(of: boujees) { _ in
          scrollToBottom()
        }
      
        // Footer for Adding LivePosts.
        AddLivePostView(forUser: user)
      }
//      .background(Color(hex: "#f5f5f2"))
      .background(.ultraThinMaterial)
      .cornerRadius(5)
      .shadow(radius: 5)
    }
    .padding()
    .frame(maxWidth: .infinity)
//    .background(Color(hex: "#dededc"))
    .cornerRadius(10)
    .overlay {
      CardGradient()
    }
    .padding()
    .shadow(radius: 7)
    .onAppear {
      startListeningBoujees()
    }
    .onDisappear {
      stopListeningBoujees()
    }
    .onTapGesture {
      hideKeyboardOnTap()
    }
    .overlay {
      LivePostTutorialView(show: $showLivePostTutorialCard)
    }
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
}

struct LiveBoujeeView_Previews: PreviewProvider {
  static var previews: some View {
    LivePostView(user: exampleUsers[0], boujees: exampleLivePosts)
  }
}
