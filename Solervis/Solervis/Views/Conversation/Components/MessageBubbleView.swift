import SwiftUI

struct MessageBubbleView: View {
    var message: String
    var isSentByCurrentUser: Bool
    var timestamp: String

    var body: some View {
        VStack(alignment: isSentByCurrentUser ? .trailing : .leading) {
            Text(message)
                .padding()
                .background(isSentByCurrentUser ? Color.green : Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            Text(timestamp)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(isSentByCurrentUser ? .trailing : .leading)
        }
        .padding(isSentByCurrentUser ? .trailing : .leading)
    }
}
