import SwiftUI

struct ConversationPage: View {
    let conversation: Conversation
    @State private var activeTabId: String
    @State private var tabsWithSharedId: [ConversationTabWithSharedId]

    init(conversation: Conversation) {
        self.conversation = conversation
        self._activeTabId = State(initialValue: conversation.tabs.first?._id ?? "")
        self._tabsWithSharedId = State(initialValue: conversation.tabs.map { tab in
            ConversationTabWithSharedId(tab: tab, sharedId: conversation.id, userId: conversation.userId)
        })
    }

    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    // Action to go back
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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabsWithSharedId, id: \.id) { tab in
                        Button(action: {
                            activeTabId = tab.id
                        }) {
                            Text(tab.title)
                                .padding()
                                .background(activeTabId == tab.id ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }

            if activeTabId == conversation.tabs.first?._id {
                BasicConv(convInfo: tabsWithSharedId.first { $0.id == activeTabId }!)
            } else {
                AdConv(convInfo: tabsWithSharedId.first { $0.id == activeTabId }!)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ConversationTabWithSharedId: Identifiable {
    let tab: ConversationTab
    let sharedId: String
    let userId: String

    var id: String { tab.id }
    var title: String { tab.title }
}
