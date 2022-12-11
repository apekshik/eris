//
//  LoginView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/11/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
  @State var isLoginMode = false
  @State private var email: String = ""
  @State private var password: String = ""
  
  init() {
    FirebaseApp.configure()
  }
  
  var body: some View {
    VStack {
      Text("ERIS")
        .font(.system(.largeTitle))
        .fontWeight(.black)
        .fontDesign(.serif)
      Divider()
      Text("Login Or Sign up")
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
        .padding()
      
      Group {
        TextField("Email", text: $email)
          .padding()
        SecureField("Password", text: $password)
          .padding()
      }
      
      Button {
        handleAction()
      } label: {
        HStack {
          Spacer()
          Text(isLoginMode ? "Login" : "Create Account")
            .foregroundColor(.white)
            .padding()
          Spacer()
        }.background(Color.black)
          .padding()
      }
      
      Spacer()
    }
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

    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
