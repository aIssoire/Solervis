import SwiftUI

struct ProfileView: View {
    @State private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State private var profile: UserProfile? = nil
    @State private var errorMessage: String? = nil

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
                        InfoRow(iconName: "house", infoText: profile.city)
                        InfoRow(iconName: "phone", infoText: "\(profile.phoneNumber)")
                        InfoRow(iconName: "briefcase", infoText: profile.job)
                        InfoRow(iconName: "heart", infoText: profile.passions.joined(separator: " - "))
                    }
                    
                    SectionHeader(title: "Communauté")
                    
                    Section(header: EmptyView()) {
                        InfoRow(iconName: "star", infoText: "\(Double(profile.totalValueRating) / Double(profile.nbRating)) / 5 sur \(profile.nbRating) avis")
                        InfoRow(iconName: "hand.thumbsup", infoText: "\(profile.nbRating) avis reçu")
                        InfoRow(iconName: "hand.thumbsdown", infoText: "\(profile.nbReviewsSent) avis rendu")
                    }
                    
                    // Ajouter ici la section des commentaires
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
}

struct InfoRow: View {
    var iconName: String
    var infoText: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
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
