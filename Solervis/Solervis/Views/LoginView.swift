import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("solervis_logo") // Assurez-vous que l'image du logo est ajoutée à vos assets
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
            
            Spacer()
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "E-Mail", imageName: "envelope", text: $email)
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
                
                CustomTextField(placeholder: "Mot de passe", imageName: "lock", text: $password, isSecure: true)
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            
            Button(action: {
                // Action pour mot de passe oublié
            }) {
                Text("Mot de passe oublié ?")
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            
            Button(action: {
                // Action pour connexion
            }) {
                Text("Connexion")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                // Action pour s'inscrire
            }) {
                Text("Pas encore de compte ?")
                    .foregroundColor(.orange)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 2)
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 30)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
