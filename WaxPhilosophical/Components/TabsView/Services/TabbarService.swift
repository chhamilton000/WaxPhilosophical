//
//  TabViewModel.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/24/23.
//

import Foundation

class TabbarService: ObservableObject{
    
    private init(){ }
    
    static var shared = TabbarService()
    
    @Published var currentTab: Tab = .Home
    @Published var tabTitle: String = "Home"
    @Published var isShowingNewTweetView = false
    
    func setCurrentTab(to selected: Tab){
        if selected != currentTab{
            currentTab = selected
            switch selected {
            case .Home:
                tabTitle = "Home"
            case .Search:
                tabTitle = "Search"
            case .Notifications:
                tabTitle = "Notifications"
            case .Messages:
                tabTitle = "Messages"
            }
        }
    }
    
    func tabTitleforTab(_ Tab: Tab) -> String {
        switch Tab {
        case .Home: return "Home"
        case .Search: return "Search"
        case .Notifications: return "Notifications"
        case .Messages: return "Messages"
        }
    }
}

enum Tab: String {
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notifications = "bell.fill"
    case Messages = "envelope.fill"
}
