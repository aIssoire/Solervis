import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedTab: Int = 0
    @State private var isTabViewHidden: Bool = false
    @State private var navigationView: AnyView? = nil
    
    var body: some View {
        ZStack {
            if isTabViewHidden, let navigationView = navigationView {
                navigationView
            } else {
                TabView(selection: $selectedTab) {
                    HomeView(navigateTo: navigateTo)
                        .tabItem {
                            Label("Accueil", systemImage: "house")
                        }
                        .tag(0)
                    
                    MarketView(navigateTo: navigateTo)
                        .tabItem {
                            Label("Market", systemImage: "cart")
                        }
                        .tag(1)
                    
                    if userSettings.isUserLoggedIn {
                        AddView(navigateTo: navigateTo)
                            .tabItem {
                                Label("Ajouter", systemImage: "plus.circle")
                            }
                            .tag(2)
                    } else {
                        LoginView(navigateTo: navigateTo)
                            .tabItem {
                                Label("Ajouter", systemImage: "plus.circle")
                            }
                            .tag(2)
                    }
                    
                    if userSettings.isUserLoggedIn {
                        MessagerieView(navigateTo: navigateTo)
                            .tabItem {
                                Label("Messagerie", systemImage: "message")
                            }
                            .tag(3)
                    } else {
                        LoginView(navigateTo: navigateTo)
                            .tabItem {
                                Label("Messagerie", systemImage: "message")
                            }
                            .tag(3)
                    }
                    
                    if userSettings.isUserLoggedIn {
                        ProfileView(navigateTo: navigateTo)
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }
                            .tag(4)
                    } else {
                        LoginView(navigateTo: navigateTo)
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }
                            .tag(4)
                    }
                }
            }
        }
        .onAppear {
            userSettings.checkLoginStatus()
        }
    }
    
    func navigateTo(_ view: AnyView, hideTabView: Bool) {
        let backView = AnyView(
            view
                .environment(\.navigateBack, navigateBack) // Pass the navigateBack function to the view
        )
        self.navigationView = backView
        self.isTabViewHidden = hideTabView
    }
    
    func navigateBack() {
        self.isTabViewHidden = false
        self.navigationView = nil
    }
}

private struct NavigateBackKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var navigateBack: (() -> Void)? {
        get { self[NavigateBackKey.self] }
        set { self[NavigateBackKey.self] = newValue }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
