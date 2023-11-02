//
//  NewTweetView.swift


import SwiftUI
import KingfisherSwiftUI

struct AddWPQuoteView: View {
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadWPQuoteViewModel
    
    var wpQuote: WPQuote?
    
    init(isPresented: Binding<Bool>, wpQuote: WPQuote?) {
        self._isPresented = isPresented
        self.viewModel = UploadWPQuoteViewModel(isPresented: isPresented, wpQuote: wpQuote)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.blue)
                })
                Spacer()
                
                Button(action: {
                    viewModel.uploadTweet(caption: captionText)
                }, label: {
                    Text("Publish")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(BlueLinearGradient())
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
            }
            .padding()
            
            if let tweet = wpQuote {
                HStack {
                    Text("Replying to")
                        .foregroundColor(.gray)
                    Text("@\(tweet.username)")
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .font(.system(size: 14))
                .padding(.leading)
            }
            
//            HStack(alignment: .top) {
//                KFImage(viewModel.profileImageUrl)
//                    .resizable()
//                    .scaledToFill()
//                    .clipped()
//                    .frame(width: 64, height: 64)
//                    .cornerRadius(32)
//
////                TextArea(viewModel.placeholderText, text: $captionText)
//
//                Spacer()
//            }
//            .padding()
            
            TextEditor(text: $captionText)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 0.5)
                        .foregroundColor(.secondary.opacity(0.5))
                }
                .font(.subheadline)
                .padding()
                .frame(height: SCREEN_HEIGHT * 0.2)
            Spacer()
        }
    }
}
