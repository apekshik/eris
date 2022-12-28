//
//  TLoginView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//

import SwiftUI

struct TLoginView: View {
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
        // handleAction()
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
  
}

struct TLoginView_Previews: PreviewProvider {
  static var previews: some View {
    TLoginView()
  }
}
