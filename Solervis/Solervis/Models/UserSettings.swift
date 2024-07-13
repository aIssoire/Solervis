import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
}
