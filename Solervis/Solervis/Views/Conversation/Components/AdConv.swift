import SwiftUI

struct AdConv: View {
    let convInfo: ConversationTabWithSharedId
    @State private var message: String = ""
    @State private var messages: [Message] = []
    @State private var websocket: URLSessionWebSocketTask?
    @State private var adInfo: AdDetail?
    @State private var userId: String = UserSettings().userId ?? ""
    @State private var isOwner: Bool = false
    
    var body: some View {
        VStack {
            // Header with Ad Actions
            if let adInfo = adInfo {
                Divider()
                VStack(alignment: .leading) {
                    Text(adInfo.title)
                        .font(.headline)
                    
                    HStack {
                        Text("\(adInfo.price)")
                            .font(.subheadline)
                        Image("coin_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                        Spacer()
                        
                        if isOwner {
                            ownerActions(for: adInfo)
                        } else {
                            userActions(for: adInfo)
                        }
                    }
                }
                .padding()
                Divider()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { msg in
                        HStack {
                            if msg.authorId == convInfo.userId {
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
        .onAppear(perform: {
            fetchMessages()
            fetchAdInfo()
            connectWebSocket()
        })
        .onDisappear(perform: {
            disconnectWebSocket()
        })
    }

    func fetchMessages() {
        guard let url = URL(string: "https://solervis.fr/api/conversation/conversation-messages?conversationId=\(convInfo.sharedId)&concernId=\(convInfo.tab.concernId ?? "")") else { return }

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

    func fetchAdInfo() {
        guard let url = URL(string: "https://solervis.fr/api/conversation/conversation-ads?conversationId=\(convInfo.sharedId)&adId=\(convInfo.tab.concernId ?? "")") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserSettings().token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching ad info: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedAdInfo = try JSONDecoder().decode(AdDetail.self, from: data)
                DispatchQueue.main.async {
                    self.adInfo = decodedAdInfo
                    self.isOwner = self.userId == decodedAdInfo.sellerId
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }

    func sendMessage() {
        guard !message.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let userId = UserSettings().userId else { return }

        let payload = SendMessagePayload(sharedId: convInfo.sharedId, concernId: convInfo.tab.concernId ?? "", authorId: userId, content: message)

        guard let url = URL(string: "https://solervis.fr/api/conversation/send-message") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserSettings().token ?? "")", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending message: \(error)")
                return
            }

            fetchMessages()
            message = ""
            
            // Send message via WebSocket
            if let websocket = websocket, websocket.state == .running {
                let messageData = WebSocketMessage(type: "message", sharedId: convInfo.sharedId, authorId: userId, content: message)
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(messageData) {
                    websocket.send(.data(encodedData)) { error in
                        if let error = error {
                            print("WebSocket error: \(error)")
                        }
                    }
                }
            }
        }.resume()
    }

    func connectWebSocket() {
        guard let userId = UserSettings().userId else { return }
        let url = URL(string: "wss://solervis.fr/ws")!
        websocket = URLSession.shared.webSocketTask(with: url)
        websocket?.resume()

        websocket?.send(.string("""
        {"type": "join", "sharedId": "\(convInfo.sharedId)", "authorId": "\(userId)"}
        """)) { error in
            if let error = error {
                print("WebSocket join error: \(error)")
            }
        }

        receiveWebSocketMessages()
    }

    func disconnectWebSocket() {
        guard let userId = UserSettings().userId else { return }
        websocket?.send(.string("""
        {"type": "leave", "sharedId": "\(convInfo.sharedId)", "authorId": "\(userId)"}
        """)) { error in
            if let error = error {
                print("WebSocket leave error: \(error)")
            }
        }
        websocket?.cancel(with: .goingAway, reason: nil)
    }

    func receiveWebSocketMessages() {
        websocket?.receive { result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("WebSocket message received: \(text)")
                    fetchMessages()
                case .data(let data):
                    print("WebSocket data received: \(data)")
                    fetchMessages()
                @unknown default:
                    fatalError()
                }
            }

            receiveWebSocketMessages()
        }
    }
    
    @ViewBuilder
    func ownerActions(for ad: AdDetail) -> some View {
        switch ad.status {
        case "requested":
            HStack {
                Button(action: { handleActionClick(action: .acceptRequest) }) {
                    Text("Valider Annonce")
                }
                Button(action: { handleActionClick(action: .declineRequest) }) {
                    Text("Refuser Annonce")
                }
            }
        case "validated":
            VStack {
                Text("Annonce Validée")
                HStack {
                    Button(action: { handleActionClick(action: .setAsComplete) }) {
                        Text("Marquer comme livré")
                    }
                    Button(action: { handleActionClick(action: .cancelJob) }) {
                        Text("Annuler la validation")
                    }
                }
            }
        case "delivered":
            Text("L'annonce va bientôt être payée par l'acheteur")
        case "payed":
            VStack {
                Text("Annonce Payée")
                Button(action: { handleActionClick(action: .closeConversation) }) {
                    Text("Clôturer la conversation")
                }
            }
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    func userActions(for ad: AdDetail) -> some View {
        switch ad.status {
        case "requested":
            Text("En attente de validation")
        case "available":
            Button(action: { handleActionClick(action: .askForValidation) }) {
                Text("Demander la validation")
            }
        case "validated":
            Text("Validée, en cours de livraison")
        case "delivered":
            Button(action: { handleActionClick(action: .payForJob) }) {
                Text("Payer et valider la réception")
            }
        case "payed":
            Button(action: { toggleReviewModal(ad) }) {
                Text("Déposer un avis")
            }
        default:
            EmptyView()
        }
    }

    func handleActionClick(action: AdAction) {
        // Add your action handling logic here, similar to the React Native code
    }

    func toggleReviewModal(_ ad: AdDetail) {
        // Add your review modal logic here
    }
}

// Define the AdAction enum
enum AdAction {
    case acceptRequest, declineRequest, setAsComplete, cancelJob, askForValidation, payForJob, closeConversation
}

// Define the AdDetail struct
struct AdDetail: Decodable {
    let id: String
    let title: String
    let price: Int
    let status: String
    let sellerId: String
}
