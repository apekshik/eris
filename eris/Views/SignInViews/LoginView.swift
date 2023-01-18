//
//  LoginView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/11/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseMessaging

struct LoginView: View {
  // Contains my user info and other related details.
  @EnvironmentObject var myData: MyData
  
  // MARK: User Details.
  @State var email: String = ""
  @State var password: String = ""
  @State var firstName: String = ""
  @State var lastName: String = ""
  @State var userName: String = ""
  @State var isLoginMode = true
  
  // MARK: Error Details.
  @State var errorMessage: String = ""
  @State var showError: Bool = false
  
  // MARK: UserDefaults
  @AppStorage("log_status") var logStatus: Bool = false
  @AppStorage("user_name") var userNameStored: String = ""
  @AppStorage("first_name") var firstNameStored: String = ""
  @AppStorage("last_name") var lastNameStored: String = ""
  
  // View Properties
  @State var isLoading: Bool = false
  
  // MARK: Main View body
  var body: some View {
    ZStack {
      BackgroundView()
      foreground
    }
  }
  
  var foreground: some View {
    VStack {
      titleSection
      
      // MARK: Picker component for login/account creation.
      Picker(selection: $isLoginMode, label: Text("Picker for login/account creation")) {
        Text("Login")
          .tag(true)
        Text("Create Account")
          .tag(false)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding([.bottom, .leading, .trailing], 16)
      .shadow(radius: 4)
      
      // MARK: Form View to enter Login/Signup details.
      Group {
        if !isLoginMode {
          createAccountView
        }
        else {
          loginAccountView
        }
      }
      .padding()
      
      signInButton
      
      Spacer()
      
      // Copyright Notice Footer
      VStack {
        Text("Copyright © 2023 Apekshik Panigrahi.")
          .font(.footnote)
        Text("All Rights Reserved.")
          .font(.footnote)
      }
//      .foregroundColor(.black)
    } // End of VStack
//    .background(Color(hex: "F5F5F4"))
    .background(.ultraThinMaterial)
    .overlay {
      LoadingView(show: $isLoading)
    }
    // Alert popup everytime there's an error.
    .alert(errorMessage, isPresented: $showError) {}
    .environmentObject(myData)
  }
  
  /// UI Components of the view start here.
  
  // MARK: Header and Title of App.
  var titleSection: some View {
    
    VStack(spacing: 8) {
      Text("BOUJÈ")
        .frame(maxWidth: .infinity)
        .font(.system(.largeTitle))
        .fontWeight(.black)
        .fontDesign(.serif)
      
      VStack( spacing: 0 ){
        Text("Created By".uppercased())
          .font(.caption2)
          .fontDesign(.rounded)
        Text("Apekshik Panigrahi".uppercased())
          .font(.caption)
          .fontWeight(.semibold)
          .fontDesign(.rounded)
      }
      
    }
//    .foregroundColor(.black)
    .padding()
  }
  
  
  var loginAccountView: some View {
    VStack(alignment: .leading) {
      Text("Enter Credentials")
        .font(.headline)
      Divider()
      TextField("Email ID", text: $email)
        .padding([.vertical])
      SecureField("Password", text: $password)
        .padding([.vertical])
        
    }
    .padding()
//    .background(Color(hex: "E1E1DF")) // 1F1F1F
    .background(.ultraThinMaterial)
    .cornerRadius(5)
    .shadow(radius: 8)
  }
  
  
  
  var createAccountView: some View {
    VStack(alignment: .leading) {
      Text("Email ID")
        .font(.headline)
      TextField("Type here", text: $email)
      
      Divider()
      Text("Full Name")
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
//    .background(Color(hex: "E1E1DF")) // 1F1F1F
//    .foregroundColor(.white)
    .background(.ultraThinMaterial)
    .cornerRadius(5)
    .shadow(radius: 8)
  }
  
  var signInButton: some View {
    // MARK: Button for Login/Signup
    Button {
      handleAction()
    } label: {
      Text(isLoginMode ? "Login" : "Create Account")
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.black)
        .background(.white)
        .cornerRadius(5)
        
    }
    .padding()
    .shadow(radius: 5)
  }
  
  
  /// Methods start here.
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
        myData.myUserProfile = try await fetchCurrentUser()
        
        // store fresh FCM token in firestore.
        let token = try await Messaging.messaging().token()
        
        let tokensRef = FirebaseManager.shared.firestore.collection("FCMTokens")
        let newToken = FCMToken(userID: myData.myUserProfile!.firestoreID,
                                token: token,
                                createdAt: Date())
        
        let _ = try tokensRef.document(myData.myUserProfile!.firestoreID).setData(from: newToken)
        myData.fcmToken = newToken
        
      } catch {
        await setError(error)
      }
    }
  }
  
  // MARK: Fetch Current User Data
  func fetchCurrentUser() async throws -> User? {
    // Fetch the current logged in user ID if user is logged in.
    guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return nil }
    // Fetch user data from Firestore using the userID.
    let user = try await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self)
    
    return user
//    // UI Updating must run on main thread.
//    await MainActor.run(body: {
//      // Setting UserDefaults and changing App's LogStatus.
//      firstNameStored = user.firstName
//      lastNameStored = user.lastName
//      userNameStored = user.userName
//      logStatus = true
//    })
  }
  
  // MARK: Signup Method
  private func createAccount() {
    isLoading = true
    Task {
      do {
        // Step 1. Create Firebase Account
        try await FirebaseManager.shared.auth.createUser(withEmail: email, password: password)
        // Step 2. Create a User object to store in Firestore using the currentUser's UID.
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let newUser = User(firestoreID: userID,
                           firstName: firstName,
                           lastName: lastName,
                           userName: userName,
                           email: email,
                           blockedUsers: [])
        
        // Step 3. Save new User data in myData EnvironmentObject
        myData.myUserProfile = newUser
        
        // Step 4. Save new User Doc in Firestore
        let db = FirebaseManager.shared.firestore
        let document = db.collection("Users").document(userID)
        try document.setData(from: newUser) { error in
          if error == nil {
            print("Saved new User Document in Firestore Successfully!")
            // store user data in UserDefaults
            logStatus = true
          }
        }
        
        // Step 5. also update the computed property "keywordsForLookup" manually since they aren't directly decodable through the firestore SDK.
        try await document.updateData(["keywordsForLookup": newUser.keywordsForLookup])
        
        // Step 6. Finally update FCM Token for new user created.
        let token = try await Messaging.messaging().token()
        
        let tokensRef = FirebaseManager.shared.firestore.collection("FCMTokens")
        let newToken = FCMToken(userID: myData.myUserProfile!.firestoreID,
                                token: token,
                                createdAt: Date())
        
        let _ = try tokensRef.document(myData.myUserProfile!.firestoreID).setData(from: newToken)
        myData.fcmToken = newToken
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
