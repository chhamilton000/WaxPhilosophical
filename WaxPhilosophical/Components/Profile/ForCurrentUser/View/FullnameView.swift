//
//  FullnameView.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/27/23.
//

import SwiftUI

struct FullnameView: View {
    @Binding var fullname: String
    var body: some View {
        Text(fullname)
    }
}

struct FullnameView_Previews: PreviewProvider {
    static var previews: some View {
        FullnameView(fullname: .constant(""))
    }
}
