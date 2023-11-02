//
//  TweetActionsView.swift


import SwiftUI

struct WPActionsView: View {
    let wpQuote: WPQuote
    @State var isShowingReplyView = false
    @ObservedObject var viewModel: WPActionViewModel
    
    init(wpQuote: WPQuote) {
        self.wpQuote = wpQuote
        self.viewModel = WPActionViewModel(wpQuote: wpQuote)
    }
    
    var body: some View {
        HStack {
            Button(action: { self.isShowingReplyView.toggle() }, label: {
                Image(systemName: "bubble.left")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
            }).sheet(isPresented: $isShowingReplyView, content: {
                AddWPQuoteView(isPresented: $isShowingReplyView, wpQuote: wpQuote)
            })
            
            Spacer()
            
//            Button(action: {}, label: {
//                Image(systemName: "arrow.2.squarepath")
//                    .font(.system(size: 16))
//                    .frame(width: 32, height: 32)
//            })
//
//            Spacer()
            
            Button(action: {
                viewModel.didLike ? viewModel.unlike() : viewModel.like()
            }, label: {
                Image(systemName: viewModel.didLike ? "heart.fill" : "heart")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
                    .foregroundColor(viewModel.didLike ? .red : .gray)
            })
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
            })
        }
        .foregroundColor(.gray)
        .padding(.horizontal)

    }
}
