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
  
  var body: some View {
    VStack {
      HStack {
        Text("Live Boujees".uppercased())
          .font(.headline)
          .fontWeight(.heavy)
          .foregroundColor(.secondary)
        Spacer()
        Image(systemName: "questionmark.circle.fill")
          .shadow(radius: 4)
      }
      
      ScrollView(.vertical, showsIndicators: false) {
        ScrollViewReader { scrollProxy in
          LazyVStack(alignment: .leading, spacing: 4) {
            ForEach(boujees) { boujee in
              VStack(alignment: .leading) {
                Text("**\(boujee.anonymous ? "anon".uppercased() : boujee.authorUsername.lowercased())** \(boujee.text)")
                  .font(.caption)
              }
            } // End of ForEach
            .onAppear {
              // Used to scroll to end of list when a new boujee is added. 
              scrollProxy.scrollTo(boujees.last?.id)
            }
          }
        }
      }
      .padding(8)
      .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 250)
      .background(Color(hex: "#f5f5f2"))
      .cornerRadius(5)
      .shadow(radius: 5)
      
      Text("*for those who aren't already bougie, it's pronounced [boo-jee].")
        .foregroundColor(.secondary)
        .font(.caption2)
      
      HStack {
        Spacer()
        Button {
          // Handle button pressing
          addBoujee = true 
        } label: {
          Text("Add Boujee")
            .padding([.horizontal])
            .padding([.vertical], 8)
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(5)
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color(hex: "#dededc"))
    .cornerRadius(10)
    .padding()
    .shadow(radius: 7)
    .overlay {
      AddLivePostView(show: $addBoujee, forUser: user)
    }
    .onAppear {
      startListeningBoujees()
    }
    .onDisappear {
      stopListeningBoujees()
    }
  }
  
  @State private var listener: ListenerRegistration?
  
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
}

struct LiveBoujeeView_Previews: PreviewProvider {
  static var previews: some View {
    LivePostView(user: exampleUsers[0], boujees: exampleLivePosts)
  }
}
