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
    // MARK: User Details.
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    @State var isLoginMode = false
    
    // MARK: Error Details.
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    
    // MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("first_name") var firstNameStored: String = ""
    @AppStorage("last_name") var lastNameStored: String = ""
    
    // View Properties
    @State var isLoading: Bool = false
    
    // MARK: Main View body
    var body: some View {
        VStack {
            
            // Header and Title of App.
            Text("BOUJÈ")
                .frame(maxWidth: .infinity)
                .font(.system(.largeTitle))
                .fontWeight(.black)
                .fontDesign(.serif)
            Divider()
            Text("Login or Sign up")
                .fontWeight(.semibold)
                .font(.system(.headline))
                .padding()
            
            // MARK: Picker component for login/account creation.
            Picker(selection: $isLoginMode, label: Text("Picker for login/account creation")) {
                Text("Login")
                    .tag(true)
                Text("Create Account")
                    .tag(false)
            }.pickerStyle(SegmentedPickerStyle())
                .padding([.bottom, .leading, .trailing], 16)
            
            // MARK: Form View to enter Login/Signup details.
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
            
            // MARK: Button for Login/Signup
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
        .overlay {
            LoadingView(show: $isLoading)
        }
        // Alert popup everytime there's an error.
        .alert(errorMessage, isPresented: $showError) {}
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
    
    // MARK: Login Method
    private func loginUser() {
        isLoading = true
        Task {
            do {
                try await FirebaseManager.shared.auth.signIn(withEmail: email, password: password)
                print("User Signed in successfully")
                logStatus = true
            } catch {
                await setError(error)
            }
        }
        // MARK: Legacy Login Method
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
    }
    
    // MARK: Signup Method
    private func createAccount() {
        isLoading = true
        Task {
            do {
                // Step 1. Create Firebase Account
                try await FirebaseManager.shared.auth.createUser(withEmail: email, password: password)
                // Step 2. Create a User object to store in Firestore using the currentUser's UID.
                guard let userUID = FirebaseManager.shared.auth.currentUser?.uid else { return }
                let newUser = User(firestoreID: userUID,
                                   firstName: firstName,
                                   lastName: lastName,
                                   userName: userName,
                                   email: email)
                // Step 3. Save new User Doc in Firestore
                let db = FirebaseManager.shared.firestore
                let document = db.collection("Users").document(userUID)
                try document.setData(from: newUser) { error in
                    if error == nil {
                        print("Saved new User Document in Firestore Successfully!")
                        // store user data in UserDefaults
                        userNameStored = userName
                        firstNameStored = firstName
                        lastNameStored = lastName
                        self.userUID = userUID
                        logStatus = true
                    }
                }
                
                // also update the computed property "keywordsForLookup" manually since they aren't directly decodable through the firestore SDK.
                try await document.updateData(["keywordsForLookup": newUser.keywordsForLookup])
                
            } catch {
                // catch any errors thrown during the account creation and firestore doc saving process.
                await setError(error)
            }
        }
        // MARK: Legacy Signup Method.
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
    }
    
    // MARK: Fetch Current User Data
    func fetchCurrentUser() async throws {
        // Fetch the current logged in user ID if user is logged in.
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        // Fetch user data from Firestore using the userID.
        let user = try await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self)
        
        // UI Updating must run on main thread.
        await MainActor.run(body: {
            // Setting UserDefaults and changing App's LogStatus.
            userUID = userID
            firstNameStored = user.firstName
            lastNameStored = user.lastName
            userNameStored = user.userName
            logStatus = true
        })
        
    }
    
    // MARK: Display Errors Via ALERT
    func setError(_ error: Error) async {
        // UI Must be updated on Main Thread.
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
