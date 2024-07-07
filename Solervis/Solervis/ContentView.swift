import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isUserLoggedIn: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house")
                }
                .tag(0)
            
            MarketView()
                .tabItem {
                    Label("Market", systemImage: "cart")
                }
                .tag(1)
            
            AddView()
                .tabItem {
                    Label("Ajouter", systemImage: "plus.circle")
                }
                .tag(2)
            
            MessagesView()
                .tabItem {
                    Label("Messagerie", systemImage: "message")
                }
                .tag(3)
            
            if isUserLoggedIn {
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(4)
            } else {
                LoginView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(4)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
