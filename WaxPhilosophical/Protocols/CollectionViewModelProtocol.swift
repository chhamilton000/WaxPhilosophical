//
//  CollectionViewModelProtocol.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/24/23.
//

import Foundation

protocol CollectionViewModelProtocol: ObservableObject where Item: Identifiable {
    associatedtype Item
    var collection: [Item] { get set }
    var isLoading: Bool { get set }
    func fetchData()
    func cacheData()
    func loadCachedData() -> [Item]?
}

extension CollectionViewModelProtocol {
    func collectionInit() {        
        if let cachedData = loadCachedData() {
            self.collection = cachedData
        }
        fetchData()
    }
}
