//
//  HomeView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        // Redirecting User based on LogStatus
        if logStatus {
            MainView()
        }
        else {
            LoginView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
