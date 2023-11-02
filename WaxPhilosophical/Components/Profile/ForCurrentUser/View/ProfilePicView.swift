//
//  ProfilePicView.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/27/23.
//

import SwiftUI
import KingfisherSwiftUI

struct ProfilePicView: View {
    @Binding var profilePic: String
    var image: UIImage?
    var body: some View {
        KFImage(URL(string: profilePic))
            .resizable()
            .scaledToFill()
            .clipped()
            .frame(width: 80, height: 80)
            .cornerRadius(40)

    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(profilePic: .constant(""))
    }
}
