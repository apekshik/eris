//
//  ProfileView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct ProfileView: View {
    // Profile Data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    // MARK: Error data
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    // MARK: Main View Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                if let myProfile {
                    Text(myProfile.userName)
                }
            }
            .refreshable {
                // TODO: Refresh User Data
                myProfile = nil
                await fetchUserData()
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        // Actions:
                        // 1. Logout
                        // 2. Delete Account
                        Button("Logout", action: logoutUser)
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Account Settings")
//                                Image(systemName: "gearshape")
//                                    .scaleEffect(1.4)
                            }
                        }
                        
                        Button("Delete Account", role: .destructive, action: deleteAccount)
                        
                    } label: { // Label for Menu
                        Image(systemName: "line.3.horizontal")
                            .tint(.black)
                            .scaleEffect(1.7)
                            
                    }
                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError) {
        }
        .task {
            if myProfile != nil { return }
            // This modifier is like onAppear, so fetches once in the beginning only.
            // MARK: Initial fetch of data for profile view.
            await fetchUserData()
        }
    }
    
    // MARK: Fetch User Data
    private func fetchUserData() async {
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let user = try? await FirebaseManager.shared.firestore.collection("Users").document(userID).getDocument(as: User.self) else { return }
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    // MARK: Logout of User Account
    private func logoutUser() {
        isLoading = true
        try? FirebaseManager.shared.auth.signOut()
        logStatus = false
    }
    
    // MARK: Delete entire User Account
    private func deleteAccount() {
        isLoading = true
        Task {
            do {
                let auth = FirebaseManager.shared.auth
                let db = FirebaseManager.shared.firestore
                guard let userID = auth.currentUser?.uid else { return }
                
                // delete User document from Firestore Database.
                try await db.collection("Users").document(userID).delete()
                // delete User's Auth account and set log status to false
                try await auth.currentUser?.delete()
                logStatus = false
            } catch {
                await setError(error)
            }
        }
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
