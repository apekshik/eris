//
//  LoginView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/11/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct LoginView: View {
  @State var isLoginMode = false
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var firstName: String = ""
  @State private var lastName: String = ""
  @State private var userName: String = ""
  
  var body: some View {
    VStack {
      
      // Header and Title of App.
      Text("ERIS")
        .frame(maxWidth: .infinity)
        .font(.system(.largeTitle))
        .fontWeight(.black)
        .fontDesign(.serif)
      Divider()
      Text("Login or Sign up")
        .fontWeight(.semibold)
        .font(.system(.headline))
        .padding()
      
      // Picker component for login/account creation.
      Picker(selection: $isLoginMode, label: Text("Picker for login/account creation")) {
        Text("Login")
          .tag(true)
        Text("Create Account")
          .tag(false)
      }.pickerStyle(SegmentedPickerStyle())
        .padding([.bottom, .leading, .trailing], 16)
      
      // Form View to enter Login/Signup details.
      Group {
        if isLoginMode == false {
          VStack(alignment: .leading) {
            Text("Enter Your Email ID")
              .font(.headline)
            TextField("Type here", text: $email)
            
            Divider()
            Text("Your Full Name")
              .font(.headline)
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            Divider()
            Text("Lastly, Your Username and Password")
              .font(.headline)
            TextField("Username", text: $userName)
            SecureField("Password", text: $password)
          }
          .padding()
          .background(Color(hex: "#f5f1dc"))
          .cornerRadius(10)
        }
        else {
          VStack(alignment: .leading) {
            Text("Enter Your Email and Password")
              .font(.headline)
            Divider()
            TextField("Email ID", text: $email)
            SecureField("Password", text: $password)
          }
          .padding()
          .background(Color(hex: "#f5f1dc"))
          .cornerRadius(10)
          
        }
      }
      .padding()
      
      // Create Account / Login Button
      Button {
        handleAction()
      } label: {
        Text(isLoginMode ? "Login" : "Create Account")
          .frame(maxWidth: .infinity)
          .padding()
          .foregroundColor(.white)
          .background(.black)
          .cornerRadius(10)
      }
      .padding()
      
      Spacer()
      
    } // End of VStack
    .background(Color(hex: "#e0ded5"))
  }
  
  private func handleAction() {
    if isLoginMode {
      print("Logging into firebase with existing creds.")
      loginUser()
    } else {
      print("registering new account inside of firebase")
      createAccount()
    }
  }
  
  // State var to catch any login/signup errors that we might encounter.
  @State var loginStatusMessage: String = ""
  
  private func loginUser() {
    Auth.auth().signIn(withEmail: email, password: password) { result, err in
      if let err = err {
        // handle error
        print("failed to login user", err.localizedDescription)
        return
      }
      
      print("succesffuly logged in user! \(result?.user.uid ?? "")")
      self.loginStatusMessage = "succesffuly logged in user! User ID: \(result?.user.uid ?? "")"
      
    }
  }
  
  
  private func createAccount() {
    Auth.auth().createUser(withEmail: email, password: password) { result, err in
      if let err = err {
        // handle error
        print("failed to create user", err.localizedDescription)
        return
      }
      
      print("succesffuly created user! \(result?.user.uid ?? "")")
      
      self.loginStatusMessage = "succesffuly created user! User ID:  \(result?.user.uid ?? "")"
      
      // also add new user to firestore database
      let newUser = User(firstName: firstName,
                         lastName: lastName,
                         userName: userName,
                         email: email)
      
      let db = FirebaseManager.shared.firestore
      
      do {
        try db.collection("Users").document().setData(from: newUser)
      }
      catch let err {
        print("Error writing data to FireStore: \(err)")
      }
      
      
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
