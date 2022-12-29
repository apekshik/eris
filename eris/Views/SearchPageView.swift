//
//  SearchPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/29/22.
//

import SwiftUI

struct SearchPageView: View {
    @State private var keyword = ""
    @State var userQueries: [User] = []
    var body: some View {
        // creating a binding so that fetchUser(containing) is called whenever the keyword changes.
        // TODO: Read more on this. It's kinda confusing how this works right now.
        let keywordBinding = Binding<String> (
            get: {
                keyword
            },
            set: {
                keyword = $0
                fetchUsers(containing: keyword)
            })
        
        // MARK: Navigation Stack for search Page
        NavigationStack {
            List {
                ForEach(userQueries, id: \.id) { user in
                    NavigationLink {
                        Text("Page to which you're redirected for \(user.fullName)")
                    } label: {
                        VStack {
                            Text(user.fullName)
                            Text("some more text")
                        }
                    }
                }
            }
            .navigationTitle("Search People")
                
        }
        .searchable(text: keywordBinding)
    }
    
    private func fetchUsers(containing keyword: String) {
        let db = FirebaseManager.shared.firestore
        db.collection("Users").whereField("keywordsForLookup", arrayContains: keyword).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else { return }
            
            // compactMap() -> Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
            userQueries = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: User.self)
            }
            
        }
    }
}

struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
