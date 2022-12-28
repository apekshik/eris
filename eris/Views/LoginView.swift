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
    
    // User Details.
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    
    // Error Details.
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    
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
    
    
    private func loginUser() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, err in
//            if let err = err {
//                // handle error
//                print("failed to login user", err.localizedDescription)
//                return
//            }
//
//            print("succesffuly logged in user! \(result?.user.uid ?? "")")
//            self.loginStatusMessage = "succesffuly logged in user! User ID: \(result?.user.uid ?? "")"
//
//        }
        
        Task {
            do {
                try await FirebaseManager.shared.auth.signIn(withEmail: email, password: password)
                print("User Signed in successfully")
            } catch {
                await setError(error)
            }
        }
    }
    
    // Displaying errors via an ALERT
    func setError(_ error: Error) async {
        // UI Must be updated on Main Thread.
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    private func createAccount() {
//        Auth.auth().createUser(withEmail: email, password: password) { result, err in
//            if let err = err {
//                // handle error
//                print("failed to create user", err.localizedDescription)
//                return
//            }
//
//            print("succesffuly created user! \(result?.user.uid ?? "")")
//
//            self.loginStatusMessage = "succesffuly created user! User ID:  \(result?.user.uid ?? "")"
//
//            let newUser = User(firstName: firstName,
//                               lastName: lastName,
//                               userName: userName,
//                               email: email)
//
//            let db = FirebaseManager.shared.firestore
//            // important to create document with the results uid since this is the signed in user's UID.
//            let userUID = result?.user.uid
//            do {
//                try db.collection("Users").document(userUID!).setData(from: newUser)
//            }
//            catch let err {
//                print("Error writing data to FireStore: \(err)")
//            }
//
//
//        }
        
        Task {
            do {
                // Step 1. Create Firebase Account
                try await FirebaseManager.shared.auth.createUser(withEmail: email, password: password)
                // Step 2. Create a User object to store in Firestore using the currentUser's UID.
                guard let userUID = FirebaseManager.shared.auth.currentUser?.uid else { return }
                let newUser = User(firstName: firstName,
                                              lastName: lastName,
                                              userName: userName,
                                              email: email)
                // Step 3. Save new User Doc in Firestore
                let db = FirebaseManager.shared.firestore
                let _ = try db.collection("Users").document(userUID).setData(from: newUser) { error in
                    if error == nil {
                        print("Saved new User Document in Firestore Successfully!")
                    }
                }
            } catch {
                // catch any errors thrown during the account creation and firestore doc saving process.
                await setError(error)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
