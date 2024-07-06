import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Accueil")
                }
            
            MarketView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Market")
                }
            
            AddView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter")
                }
            
            MessagesView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messagerie")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
