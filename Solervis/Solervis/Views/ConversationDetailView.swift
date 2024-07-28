import SwiftUI

struct ConversationDetailView: View {
    let conversation: Conversation

    var body: some View {
        Text("Conversation avec \(conversation.username)")
            .navigationTitle(conversation.username)
    }
}
