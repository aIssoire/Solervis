import Foundation

struct NotificationResponse: Decodable {
    let notifications: [NotificationGroup]
}

struct NotificationGroup: Decodable {
    let id: String
  
    let version: Int
    let notifications: [NotificationData]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"

        case version = "__v"
        case notifications
    }
}

struct NotificationData: Identifiable, Decodable {
    var id: String
    var notificationType: String
    var notificationContent: String
    var timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case notificationType = "notification_type"
        case notificationContent = "notification_content"
        case timestamp
    }
}
