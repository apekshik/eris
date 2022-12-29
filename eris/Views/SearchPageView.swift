//
//  SearchPageView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/29/22.
//

import SwiftUI

struct SearchPageView: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink {
                        Text("Page to which you're redirected for \(name)")
                    } label: {
                        VStack {
                            Text(name)
                            Text("some more text")
                        }
                    }
                }
            }
            .navigationTitle("Search People")
                
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
