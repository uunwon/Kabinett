//
//  ProfileView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct ProfileView: View {
//     var userName: String
//     var userNumber: String

     var body: some View {
         VStack{
             Circle()
                 .foregroundColor(.primary300)
                 .frame(width: 110)
                 .padding(.bottom, -1)
             Text("userName")
                 .fontWeight(.regular)
                 .font(.system(size: 36))
                 .padding(.bottom, 0.1)
            Text("000-000")
                .fontWeight(.light)
                .font(.system(size: 16))
                .monospaced()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
     }
 }

#Preview {
    ProfileView()
}
