//
//  FeedView.swift


import SwiftUI

struct WPQuoteCollectionView: View {
    @State var isShowingNewTweetView = false
    @ObservedObject var viewModel = WPQuote_CollectionViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    ForEach(viewModel.collection) { quote in
                        NavigationLink(destination: WPQuoteDetailView(wpQuote: quote)) {
                            WPQuoteCell(wpQuote: quote)
                        }
                    }
                }
                .padding([.horizontal,.top])
            }
        }
        .BottomPaddingBecauseOfCustomTabbar()
        .refreshable {
            withAnimation {
                viewModel.fetchData()
            }
        }
    }
}
