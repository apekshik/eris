//
//  ReportFormView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/5/23.
//

import SwiftUI

struct ReportFormView: View {
  @State var user: User
  @State var review: Review? = nil
  @Binding var show: Bool
  
  
  @State var reportContent: String = ""
  
  var body: some View {
    VStack {
      Button {
        show = false
      } label: {
        Image(systemName: "xmark.circle.fill")
          .resizable()
          .frame(width: 35, height: 35)
          .tint(.black)
      }
      .padding([.bottom])
      Form {
        
        Section(header: Text("Details"), footer: Text("* Required to submit")) {
          Text("Why are you reporting this user?*")
          TextField("Type here", text: $reportContent, axis: .vertical)
            .lineLimit(5, reservesSpace: true)
//            .textFieldStyle(.roundedBorder)
        }
        
        Button("Submit Report".uppercased()) {
          // TODO: handle errors properly.
          handleFormSubmit()
          show = false
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(.black)
      }
      .cornerRadius(10)
      .shadow(radius: 5)
    }
    .frame(maxHeight: 430)
    .padding()
  }
  
  private func handleFormSubmit() {
    do {
      guard let myID = FirebaseManager.shared.auth.currentUser?.uid else { return }
      var report: Report
      if review == nil {
        report = Report(authorID: myID, userID: user.firestoreID, content: reportContent)
      } else {
        report = Report(authorID: myID, userID: user.firestoreID, content: reportContent, reviewID: review!.reviewID)
      }
      
      let reportsRef = FirebaseManager.shared.firestore.collection("Reports")
      try reportsRef.addDocument(from: report)
    } catch {
      // TODO: HANDLE ERROR PLEASE. 
    }
  }
}

struct ReportFormView_Previews: PreviewProvider {
  static var previews: some View {
    ReportFormView(user: exampleUsers[0], show: .constant(true))
  }
}
