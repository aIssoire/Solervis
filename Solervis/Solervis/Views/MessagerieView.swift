import SwiftUI

struct MessagerieView: View {
    @State private var searchTerm: String = ""
    @State private var conversations: [Conversation] = []
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                // Messages Header
                Text("Messagerie")
                    .font(.largeTitle)
                    .bold()
                
                // Search Bar
                CustomSearchBar(text: $searchTerm)
                    .scenePadding(.bottom)

                // Conversation List
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(filteredConversations, id: \.id) { convo in
                                NavigationLink(destination: ConversationView(conversation: convo)) {
                                    HStack {
                                        if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(convo.profilePicturePath ?? "")") {
                                            AsyncImageLoader(url: url)
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        }
                                        
                                        Text(convo.username)
                                            .font(.headline)
                                        Spacer()
                                        
                                    }
                                    .padding(.vertical, 5)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: fetchConversations)
        }
    }

    var filteredConversations: [Conversation] {
        if searchTerm.isEmpty {
            return conversations
        } else {
            return conversations.filter { $0.username.lowercased().contains(searchTerm.lowercased()) }
        }
    }

    func fetchConversations() {
        guard let url = URL(string: "https://solervis.fr/api/conversation/conversations") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserSettings().token ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching conversations: \(error)")
                isLoading = false
                return
            }

            guard let data = data else {
                print("No data received")
                isLoading = false
                return
            }

            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response data: \(jsonString)")
                }

                let decodedConversations = try JSONDecoder().decode([Conversation].self, from: data)
                DispatchQueue.main.async {
                    self.conversations = decodedConversations
                    self.isLoading = false
                    
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                isLoading = false
            }
        }.resume()
    }
}

struct MessagerieView_Previews: PreviewProvider {
    static var previews: some View {
        MessagerieView()
            .environmentObject(UserSettings())
    }
}
