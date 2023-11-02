//
//  NotificationsView.swift


import SwiftUI

struct NotificationsView: View {
    @ObservedObject var viewModel = NotificationViewModel()
    
    var body: some View {
        if viewModel.notifications.isEmpty{
            Text("You have no notifications at this time")
                .foregroundColor(.primary.opacity(0.5))
                .font(.system(size: 20, weight: .semibold))
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                    }
                }.padding()
            }
            .BottomPaddingBecauseOfCustomTabbar()
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(viewModel: NotificationViewModel())
    }
}
