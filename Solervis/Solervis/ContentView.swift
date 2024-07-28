import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedTab: Int = 0
    
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
            
            if userSettings.isUserLoggedIn {
                AddView()
                    .tabItem {
                        Label("Ajouter", systemImage: "plus.circle")
                    }
                    .tag(2)
            } else {
                LoginView()
                    .tabItem {
                        Label("Ajouter", systemImage: "plus.circle")
                    }
                    .tag(2)
            }
            
            if userSettings.isUserLoggedIn {
                MessagesView()
                    .tabItem {
                        Label("Messagerie", systemImage: "message")
                    }
                    .tag(3)
            } else {
                LoginView()
                    .tabItem {
                        Label("Messagerie", systemImage: "message")
                    }
                    .tag(3)
            }
            
            if userSettings.isUserLoggedIn {
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
        .onAppear {
                    userSettings.checkLoginStatus()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
