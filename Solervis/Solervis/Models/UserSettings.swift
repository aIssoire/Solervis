import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var isUserLoggedIn: Bool = false {
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
    
    init() {
        self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        self.token = UserDefaults.standard.string(forKey: "token")
        self.userId = UserDefaults.standard.string(forKey: "userId")
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        guard let token = self.token else {
            self.isUserLoggedIn = false
            return
        }

        guard let url = URL(string: "https://solervis.fr/api/user/auth/session") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.refreshToken()
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.refreshToken()
                return
            }

            DispatchQueue.main.async {
                self.isUserLoggedIn = true
            }
        }.resume()
    }
    
    func refreshToken() {
        guard let url = URL(string: "https://solervis.fr/api/user/auth/refresh") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let newToken = json["token"] as? String {
                    DispatchQueue.main.async {
                        self.token = newToken
                        self.isUserLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isUserLoggedIn = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
            }
        }.resume()
    }
    
    func logout() {
        self.isUserLoggedIn = false
        self.token = nil
        self.userId = nil
    }
}

