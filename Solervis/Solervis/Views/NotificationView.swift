import SwiftUI

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var notifications: [NotificationData] = []
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Notifications")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
                    .foregroundColor(.clear)
            }
            .padding()

            ScrollView {
                VStack(spacing: 0) {
                    if notifications.isEmpty {
                        ProgressView()
                            .onAppear(perform: fetchNotifications)
                    } else {
                        ForEach(notifications) { notification in
                            NotificationRow(notification: notification)
                                .padding(.horizontal)
                                .padding(.top, 10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .gesture(DragGesture().onEnded { value in
            if value.translation.width > 100 {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func fetchNotifications() {
        guard let url = URL(string: "https://solervis.fr/api/notification/notifications") else {
            self.errorMessage = "URL invalide."
            print("URL invalide")
            return
        }
        
        print("Fetching data from: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de requête : \(error.localizedDescription)"
                    print("Erreur de requête:", error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Données non reçues."
                    print("Données non reçues")
                }
                return
            }
            
            print("Données reçues:", String(data: data, encoding: .utf8) ?? "Impossible de convertir les données en chaîne")
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode(NotificationResponse.self, from: data)
                DispatchQueue.main.async {
                    if let firstNotifications = decodedResponse.notifications.first?.notifications {
                        self.notifications = firstNotifications
                    } else {
                        self.errorMessage = "Aucune notification disponible."
                        print("Aucune notification disponible")
                    }
                    print("Notifications décodées:", self.notifications)
                }
            } catch let decodingError {
                print("Erreur de décodage:", decodingError)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Structure du JSON reçu:", json)
                    }
                } catch {
                    print("Impossible de convertir les données en dictionnaire:", error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de décodage : \(decodingError.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct NotificationRow: View {
    var notification: NotificationData
    
    var body: some View {
        HStack(alignment: .top) {
            Image(getIcon(notification.notificationType))
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(notification.notificationContent)
                    .font(.body)
                    .padding(.vertical, 2)
                Text("Il y a \(getTimeDifference(notification.timestamp))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
    
    func getIcon(_ type: String) -> String {
        switch type {
        case "purchase":
            return "rayon_icon"
        case "commentary":
            return "notifCom_icon"
        case "new_like":
            return "notifLike_icon"
        case "new_ad":
            return "notifAdd_icon"
        case "new_message":
            return "notifMsg_icon"
        case "rate":
            return "notifRate_icon"
        default:
            return "default_icon"
        }
    }
    
    func getTimeDifference(_ notificationDate: String) -> String {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: notificationDate) else { return "Inconnu" }
        let diff = now.timeIntervalSince(date)
        let minutes = Int(diff / 60)
        let hours = Int(diff / 3600)
        let days = Int(diff / 86400)

        if minutes < 60 {
            return "\(minutes) min"
        } else if hours < 24 {
            return "\(hours) h"
        } else {
            return "\(days) j"
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
