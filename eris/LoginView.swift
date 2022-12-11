//
//  LoginView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/11/22.
//

import SwiftUI

struct LoginView: View {
  @State var isLoginMode = false
  @State private var email: String = ""
  @State private var password: String = ""
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
  
  func login() {
    
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
