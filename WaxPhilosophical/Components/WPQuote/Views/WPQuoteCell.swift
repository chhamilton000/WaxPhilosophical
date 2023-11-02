//
//  TweetCell.swift
//
//  Created by Caley Hamilton on 10/18/23.
//


import SwiftUI
import KingfisherSwiftUI

struct WPQuoteCell: View {
    let wpQuote: WPQuote
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                KFImage(URL(string: wpQuote.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(56 / 2)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {

                        
                        Text(wpQuote.fullname)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        
                        Text("•")
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .semibold))
                        
                        Text("@\(wpQuote.username)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: SCREEN_WIDTH * 0.35)
                        
                        Text("•")
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .semibold))
                        
                        Text(wpQuote.timestampString)
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .semibold))

                    }
                    
                    Text(wpQuote.caption)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                }
            }
            .padding(.trailing)
            
            WPActionsView(wpQuote: wpQuote)
            
            Divider()
                .padding(.leading)
        }
        .padding(.leading, -16)
    }
}

struct TweetCell_Previews: PreviewProvider{
    static var previews: some View{
        WPQuoteCell(wpQuote: WPQuote(dictionary: [
            "caption": "Treat a work of art like a prince. Let it speak to you first.",
            "fullname": "Arthur Schopenhauer",
            "id": "slAy9TsFxsB0DpAvBG41",
            "likes": 10,
            "profileImageUrl": "https://firebasestorage.googleapis.com/v0/b/twitterklonos.appspot.com/o/EA5405C6-6323-45EC-B737-50408B619A8E?alt=media&token=1460aef3-3f3f-4dff-8991-624135d8609c",
            "timestamp": Date().timeIntervalSinceReferenceDate,
            "uid": "1hPWpyLx9NcQinbL2rjITdU1WFm1",
            "username": "arthur_schopenhauer"
        ]))
    }
}

