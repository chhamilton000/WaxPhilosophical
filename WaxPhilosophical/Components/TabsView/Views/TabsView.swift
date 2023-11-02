//
//  MainTabView.swift


import KingfisherSwiftUI
import SwiftUI

struct TabsView: View {
    
    init(user: AppUser) {
        self._user = State(initialValue: user)
//        self._user = State(wrappedValue: user)
        UITabBar.appearance().isHidden = true
    }
    
    @State var user: AppUser

    @EnvironmentObject var authService: AuthService
    @StateObject var tabbarService = TabbarService.shared
//    @EnvironmentObject var userService: UserService
    
    @State private var showMenu = false
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        NavigationView  {
                HStack(spacing: 0){
                    
                    MenuView(user: $user, showMenu: $showMenu)
                    
                    ZStack{
                        VStack{
                            ZStack{
                                Text(tabbarService.tabTitleforTab(tabbarService.currentTab))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                HStack{
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            self.showMenu.toggle()
                                        }
                                    }, label: {
                                        KFImage(URL(string: user.profileImageUrl ?? ""))
                                                .resizable()
                                                .scaledToFill()
                                                .clipped()
                                                .frame(width: 32, height: 32)
                                                .cornerRadius(16)
                                        
                                    })
                                    .padding(.horizontal)
                                    Spacer()
                                }
                            }
                            
                            TabView(selection: $tabbarService.currentTab) {
                                
                                WPQuoteCollectionView()
                                    .tabItem { Image(systemName: "house") }
                                    .tag( Tab.Home )
                                
                                SearchView(viewModel: SearchViewModel(config: .search))
                                    .tabItem { Image(systemName: "magnifyingglass") }
                                    .tag( Tab.Search )
                                
                                NotificationsView()
                                    .tabItem { Image(systemName: "bell.fill") }
                                    .tag( Tab.Notifications )
                                
                                MessagesView()
                                    .tabItem { Image(systemName: "envelope.fill") }
                                    .tag( Tab.Messages )
                                
                            }
                        }
                        .overlay{ tabBarComponent() }
                        
                        Color.gray.opacity(0.5)
                            .ignoresSafeArea()
                            .opacity(showMenu ? 1 : 0)
                            .onTapGesture { if showMenu{ showMenu = false} }
                    }
                }
                .environmentObject(tabbarService)
                .sheet(isPresented: $tabbarService.isShowingNewTweetView) {
                    if #available(iOS 16.0, *){
                        AddWPQuoteView(isPresented: $tabbarService.isShowingNewTweetView, wpQuote: nil)
                            .presentationDetents([.fraction(0.35)])
                    } else {
                        AddWPQuoteView(isPresented: $tabbarService.isShowingNewTweetView, wpQuote: nil)
                    }
                }
                .modifier(SideMenuAction(showMenu: $showMenu, offset: $offset))
            }
    }
    
}

fileprivate extension TabsView{
    
    @ViewBuilder
    func tabButton(for Tab: Tab)-> some View {
        Button {
            tabbarService.setCurrentTab(to: Tab)
        } label: {
            Image(systemName: Tab.rawValue)
                .renderingMode(.template)
                .font(.system(size: 24))
                .foregroundLinearGradient(with: tabbarService.currentTab == Tab ?
                                            BlueLinearGradient() :
                                            LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                .frame(maxWidth: .infinity)
        }
    }
    
    func tabBarComponent() -> some View{
        VStack {
            Spacer()
            HStack(spacing: 0){
                tabButton(for: .Home)
                tabButton(for: .Search)
                    .offset(x: -10)
                
                Button{
                    withAnimation {
                        tabbarService.isShowingNewTweetView.toggle()
                    }
                } label: {
                    Image("philosophyIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 50)
                        .padding(8)
                        .background{ BlueLinearGradient().clipShape(Circle())}
                        .offset(y:-30)
                }
                tabButton(for: .Notifications)
                tabButton(for: .Messages)
                
            }
            .background(
                Color.white
                    .clipShape(
                        ConcaveTabbarShape()
                    )
                    .foregroundColor(.primary)
                //MARK: - SHADOW
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
                    .ignoresSafeArea(.container, edges: .bottom)
            )
            //                .padding(.bottom, 18)
        }
    }

    func tabViewModifier(_ showMenu: Bool) -> some View {
        self
            .cornerRadius(showMenu ? 20 : 10)
            .offset(x: showMenu ? 300 : 0,
                    y: showMenu ? 44 : 0)
            .opacity(showMenu ? 0.25 : 1)
            .scaleEffect(showMenu ? 0.9 : 1)
            .shadow(color: showMenu ? .black : .clear,
                    radius: 20, x: 0, y: 0)
            .disabled(showMenu)
    }
    
}



struct MainTabView_Previews: PreviewProvider{
    static var previews: some View{
        @State var user: AppUser = .init(username: "", fullname: "", email: "")
        TabsView(user: user)
            .environmentObject(TabbarService.shared)
    }
}
