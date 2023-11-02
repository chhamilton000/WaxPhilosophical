//
//  Tweet.swift


import Firebase

struct WPQuote: Identifiable {
    let id: String
    let username: String
    let profileImageUrl: String
    let fullname: String
    let caption: String
    let likes: Int
    let uid: String
    let timestamp: Timestamp
    var replyingTo: String?
        
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.replyingTo = dictionary["replyingTo"] as? String
    }
    
    init(id: String = UUID().uuidString,
         username: String = "arthur_schopenhauer",
         profileImageUrl: String = "https://firebasestorage.googleapis.com/v0/b/twitterklonos.appspot.com/o/EA5405C6-6323-45EC-B737-50408B619A8E?alt=media&token=1460aef3-3f3f-4dff-8991-624135d8609c",
         fullname: String = "Arthur Schopenhauer",
         caption: String,
         likes: Int = 10,
         uid: String = "1hPWpyLx9NcQinbL2rjITdU1WFm1",
         timestamp: Timestamp = .init(date: Date()),
         replyingTo: String = ""
    ){
        self.id = id
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.fullname = fullname
        self.caption = caption
        self.likes = likes
        self.uid = uid
        self.timestamp = timestamp
        self.replyingTo = replyingTo
    }
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: timestamp.dateValue())
    }
}
