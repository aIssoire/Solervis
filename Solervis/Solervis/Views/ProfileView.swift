import SwiftUI

struct ProfileView: View {
    @State private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State private var profile: UserProfile? = nil
    @State private var errorMessage: String? = nil
    @State private var comments: [Comment] = []
    
    var body: some View {
        ScrollView {
            if let profile = profile {
                VStack(alignment: .leading) {
                    // Ligne 1
                    HStack {
                        if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(profile.profilePicturePath)") {
                            AsyncImageLoader(url: url)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        
                        Text("\(profile.rayons)")
                            .font(.title)
                            .bold()
                        
                        Image("add_coin_icon") // Assurez-vous que l'icône est ajoutée aux assets
                            .resizable()
                            .frame(width: 38, height: 25)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                // Action pour notifications
                            }) {
                                Image("notification_icon") // Assurez-vous que l'icône est ajoutée aux assets
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            Button(action: {
                                // Action pour favoris
                            }) {
                                Image("favorite_icon") // Assurez-vous que l'icône est ajoutée aux assets
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            Button(action: {
                                // Action pour paramètres
                            }) {
                                Image("settings_icon") // Assurez-vous que l'icône est ajoutée aux assets
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    
                    // Ligne 2
                    HStack {
                        Text(profile.username)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            // Action pour modifier le profil
                        }) {
                            Text("Modifier")
                                .padding(12)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.top, 4)
                    
                    // Ligne 3
                    Text(profile.description)
                        .font(.subheadline)
                        .padding(.bottom, 4)
                    
                    SectionHeader(title: "Infos Personnelles")
                    
                    Section(header: EmptyView()) {
                        InfoRow(iconName: "pin_p", infoText: profile.city) // Remplacer les noms d'icônes
                        InfoRow(iconName: "phone_p", infoText: "\(profile.phoneNumber)")
                        InfoRow(iconName: "job_p", infoText: profile.job)
                        InfoRow(iconName: "passion_p", infoText: profile.passions.joined(separator: " - "))
                    }
                    
                    SectionHeader(title: "Communauté")
                    
                    Section(header: EmptyView()) {
                        InfoRow(iconName: "rate_p", infoText: "\(Double(profile.totalValueRating) / Double(profile.nbRating)) / 5 sur \(profile.nbRating) avis")
                        InfoRow(iconName: "review_p", infoText: "\(profile.nbRating) avis reçu")
                        InfoRow(iconName: "given_review_p", infoText: "\(profile.nbReviewsSent) avis rendu")
                    }
                    
                    SectionHeader(title: "Commentaires")
                    
                    if comments.isEmpty {
                        ProgressView()
                            .onAppear(perform: fetchComments)
                    } else {
                        ForEach(comments) { comment in
                            CommentRow(comment: comment)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                    }
                }
                .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ProgressView()
                    .onAppear(perform: fetchProfile)
            }
            Button(action: {
                // Action pour "Mes offres"
            }) {
                Text("Mes offres")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func fetchProfile() {
        guard let url = URL(string: "https://solervis.fr/api/user/me") else {
            self.errorMessage = "URL invalide."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de requête : \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Données non reçues."
                }
                return
            }
            
            do {
                let decodedProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.profile = decodedProfile
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func fetchComments() {
        guard let userId = UserDefaults.standard.string(forKey: "userId"),
              let url = URL(string: "https://solervis.fr/api/review/get/user/\(userId)") else {
            self.errorMessage = "Invalid user ID or URL."
            print("Invalid user ID or URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
        
        print("Sending request to URL:", url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Request error: \(error.localizedDescription)"
                    print("Request error:", error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received."
                    print("No data received.")
                }
                return
            }
            
            print("Data received:", String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
            
            do {
                let decodedComments = try JSONDecoder().decode([Comment].self, from: data)
                DispatchQueue.main.async {
                    self.comments = decodedComments
                    print("Commentaires décodés:", decodedComments)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("Decoding error:", error.localizedDescription)
                }
            }
        }.resume()
    }
    
}

struct CommentRow: View {
    var comment: Comment
    
    var body: some View {
        HStack(alignment: .top) {
            if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(comment.sender.profilePicturePath)") {
                AsyncImageLoader(url: url)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.sender.name)
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(comment.grade)")
                            .font(.subheadline)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                Text(comment.comment)
                    .font(.body)
                    .padding(.vertical, 2)
                Text("il y a \(formatDate(comment.date))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
    
    func formatDate(_ date: String) -> String {
        // Format the date string as needed
        return "un mois" // Example, replace with actual date formatting
    }
}


struct InfoRow: View {
    var iconName: String
    var infoText: String
    
    var body: some View {
        HStack {
            Image(iconName) // Utilisation des images dans les assets
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.orange)
            Text(infoText)
        }
        .padding(.vertical, 4)
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.gray)
            .padding(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemGray6))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
