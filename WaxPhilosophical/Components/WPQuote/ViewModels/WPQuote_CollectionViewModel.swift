//
//  FeedViewModel.swift

import Foundation
import FirebaseFirestore

final class WPQuote_CollectionViewModel: ObservableObject, CollectionViewModelProtocol {
    typealias Item = WPQuote

    @Published var collection: [Item] = []
    @Published var isLoading: Bool = false
    
    static let cache = NSCache<NSString, NSArray>()

    init() { collectionInit() }

    func fetchData() {
        self.isLoading = true
        WPQOUTE_COLLECTION.getDocuments { snapshot, error in
            self.isLoading = false
            
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                guard let documents = snapshot?.documents else { return }
                self.collection = documents.map({ WPQuote(dictionary: $0.data()) })
                self.cacheData()
            }
        }
    }
    
    func cacheData() {
        WPQuote_CollectionViewModel.cache.setObject(self.collection as NSArray, forKey: "cachedWPQuotes")
    }

    func loadCachedData() -> [Item]? {
        return WPQuote_CollectionViewModel.cache.object(forKey: "cachedWPQuotes") as? [Item]
    }
}
