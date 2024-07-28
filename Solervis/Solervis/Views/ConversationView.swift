import SwiftUI

struct ConversationView: View {
    let conversation: Conversation
    @State private var message: String = ""
    @State private var messages: [Message] = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding(.leading)
                }

                if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(conversation.profilePicturePath ?? "")") {
                    AsyncImageLoader(url: url)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }

                Text(conversation.username)
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                
                Spacer()
            }
            .padding()

            Divider()

            // Messages
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { msg in
                        HStack {
                            if msg.authorId == conversation.userId {
                                MessageBubbleView(message: msg.content, isSentByCurrentUser: false, timestamp: msg.timestamp)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                MessageBubbleView(message: msg.content, isSentByCurrentUser: true, timestamp: msg.timestamp)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding()
            }

            Divider()

            // Input field and send button
            HStack {
                TextField("Ecrivez votre message...", text: $message)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(25)
                    .padding(.leading)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .padding(.trailing)
                }
            }
            .padding()
        }
        .onAppear(perform: fetchMessages)
        .navigationBarHidden(true)
    }

    func fetchMessages() {
        guard let url = URL(string: "https://solervis.fr/api/conversation/conversation-messages?conversationId=\(conversation.id)&concernId=\(conversation.tabs.first?.concernId ?? "")") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserSettings().token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response data: \(jsonString)")
                }

                let decodedResponse = try JSONDecoder().decode(ConversationDetail.self, from: data)
                DispatchQueue.main.async {
                    self.messages = decodedResponse.messages
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }

    func sendMessage() {
        guard let url = URL(string: "https://solervis.fr/api/conversation/send-message") else { return }
        guard let userId = UserSettings().userId else { return }

        let payload: [String: Any] = [
            "sharedId": conversation.id,
            "concernId": conversation.tabs.first?.concernId ?? "",
            "authorId": userId,
            "content": message
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserSettings().token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending message: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let newMessage = try JSONDecoder().decode(Message.self, from: data)
                DispatchQueue.main.async {
                    self.messages.append(newMessage)
                    self.message = ""
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}

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
