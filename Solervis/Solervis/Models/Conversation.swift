import Foundation

struct ConversationTab: Identifiable, Decodable {
    var id: String { _id }
    let timestamp: String
    let concernId: String?
    let title: String
    let _id: String
}

struct Conversation: Identifiable, Decodable {
    let id: String
    let userId: String
    let tabs: [ConversationTab]
    let username: String
    let profilePicturePath: String?
}

struct Message: Identifiable, Decodable {
    var id: String { _id }
    let authorId: String
    let content: String
    let timestamp: String
    let _id: String
}

struct ConversationDetail: Decodable {
    let id: String
    let sharedId: String
    let concernId: String
    let messages: [Message]
}
