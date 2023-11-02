//
//  ReplyCell.swift


import SwiftUI

struct ReplyCell: View {
    let wpQuote: WPQuote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
                
                Text("replying to")
                    .foregroundColor(.gray)
                
                Text("@\(wpQuote.replyingTo ?? "")")
                    .foregroundColor(.blue)
            }
            .padding(.leading)
            .font(.system(size: 12))
            
            WPQuoteCell(wpQuote: wpQuote)
        }
    }
}

