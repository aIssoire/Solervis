import SwiftUI

struct SettingsButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 32, height: 32)
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}

struct ParameterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Paramètres")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer() // Ensure the title stays centered
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
                
                Group {
                    Text("Général")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    
                    SettingsButton(icon: "bell", title: "Notifications") {
                        // Navigate to NotificationScreen
                    }
                    SettingsButton(icon: "gearshape", title: "Gestion des notifications") {
                        // Navigate to CheckNotificationScreen
                    }
                    SettingsButton(icon: "globe", title: "Langues") {
                        // Navigate to LangueScreen
                    }
                }
                
                Group {
                    Text("Abonnement")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    
                    SettingsButton(icon: "person.crop.circle", title: "Status du compte") {
                        // Action for Status du compte
                    }
                    SettingsButton(icon: "questionmark.circle", title: "FAQ Solervis") {
                        // Navigate to FaqScreen
                    }
                }
                
                Group {
                    Text("Confidentialité")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    
                    SettingsButton(icon: "lock.shield", title: "Confidentialité du compte") {
                        // Action for Confidentialité du compte
                    }
                    SettingsButton(icon: "eye.slash", title: "Mots masqués") {
                        // Navigate to MasquesScreen
                    }
                    SettingsButton(icon: "hand.raised.slash", title: "Bloqué") {
                        // Action for Bloqué
                    }
                }
                
                Group {
                    Text("Plus d'infos et d'assistances")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    
                    SettingsButton(icon: "questionmark.circle.fill", title: "Aide") {
                        // Navigate to AideScreen
                    }
                    SettingsButton(icon: "info.circle", title: "À propos") {
                        // Navigate to AProposScreen
                    }
                }
                
                Group {
                    Text("Connexion")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    
                    SettingsButton(icon: "arrow.right.square", title: "Se déconnecter") {
                        handleLogoutAndNavigate()
                    }
                    SettingsButton(icon: "trash", title: "Supprimer son compte") {
                        // Action for Supprimer son compte
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .gesture(DragGesture().onEnded { value in
            if value.translation.width > 100 {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func handleLogoutAndNavigate() {
            userSettings.logout()
            presentationMode.wrappedValue.dismiss()
            
            // Redirection vers l'écran de connexion ou d'accueil
        }
}

struct ParametreScreen_Previews: PreviewProvider {
    static var previews: some View {
        ParameterView()
    }
}
