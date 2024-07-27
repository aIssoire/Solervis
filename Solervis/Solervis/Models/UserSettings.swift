import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
        didSet {
            UserDefaults.standard.set(self.isUserLoggedIn, forKey: "isUserLoggedIn")
        }
    }
    
    @Published var token: String? {
        didSet {
            UserDefaults.standard.set(self.token, forKey: "token")
        }
    }
    
    @Published var userId: String? {
        didSet {
            UserDefaults.standard.set(self.userId, forKey: "userId")
        }
    }
}
