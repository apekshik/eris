//
//  AboutSheetView.swift
//  eris
//
//  Created by Apekshik Panigrahi on 1/5/23.
//

import SwiftUI

struct AboutSheetView: View {
    var body: some View {
      VStack(spacing: 30) {
        VStack(spacing: 16 ){
          VStack(alignment: .leading, spacing: 12 ){
            Text("Dreamt,\nDesigned &\nDeveloped By".uppercased())
              .fontDesign(.serif)
              .fontWeight(.light)
              .opacity(0.8)
            Text("© Apekshik Panigrahi".uppercased())
              .font(.title2)
              .fontWeight(.semibold)
              .fontDesign(.serif)
          }
          
          // Address
          VStack(spacing: 12){
            VStack(spacing: 0){
              Text("Minneapolis, MN".uppercased())
              Text("USA, 55414.".uppercased())
            }
            
            Text("apekshik.bouje@gmail.com")
              .tint(.white)
              .opacity(0.7)
          }
          .foregroundColor(.secondary)
        }
        
        Text("BOUJÈ")
          .font(.system(.largeTitle))
          .fontWeight(.heavy)
          .fontDesign(.serif)
        
        // Copyright Notice Footer
        VStack {
          Text("Copyright © 2023 Apekshik Panigrahi.")
            .font(.footnote)
          Text("All Rights Reserved.")
            .font(.footnote)
        }
        
      }
    }
}

struct AboutSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSheetView()
    }
}
