import Foundation

// Model for individual conversation tab
struct ConversationTab: Identifiable, Decodable {
    var id: String { _id }
    let timestamp: String
    let concernId: String?
    let title: String
    let _id: String
}

// Model for conversation
struct Conversation: Identifiable, Decodable {
    let id: String
    let userId: String
    let tabs: [ConversationTab]
    let username: String
    let profilePicturePath: String?
}
