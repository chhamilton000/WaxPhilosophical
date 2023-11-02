//
//  TweetDetailView.swift


import SwiftUI
import KingfisherSwiftUI

struct WPQuoteDetailView: View {
    let wpQuote: WPQuote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                KFImage(URL(string: wpQuote.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(wpQuote.fullname)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text("@\(wpQuote.username)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Text(wpQuote.caption)
                .font(.system(size: 22))
            
            Text(wpQuote.detailedTimestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Divider()
            
            HStack(spacing: 12) {
//                HStack(spacing: 4) {
//                    Text("0")
//                        .font(.system(size: 14, weight: .semibold))
//
//                    Text("Reposts")
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                }
                
                HStack(spacing: 4) {
                    Text("\(wpQuote.likes)")
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text("Likes")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            WPActionsView(wpQuote: wpQuote)
            
            Spacer()
        }
        .padding()
    }
}
