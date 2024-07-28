import SwiftUI

struct FavoritesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var favorites: [CardData] = []
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Favoris")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding()

            ScrollView {
                VStack(spacing: 0) {
                    if favorites.isEmpty {
                        ProgressView()
                            .onAppear(perform: fetchFavorites)
                    } else {
                        ForEach(favorites) { favorite in
                            CardView(
                                imageURL: favorite.imageURL,
                                title: favorite.title,
                                location: favorite.location,
                                price: favorite.price,
                                userName: favorite.userName,
                                userImageURL: favorite.userImageURL,
                                rating: favorite.rating,
                                isFavorite: favorite.isFavorite ?? false,
                                itemId: favorite.id
                            )
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func fetchFavorites() {
        guard let url = URL(string: "https://solervis.fr/api/user/favorite/ads") else {
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
                let decodedFavorites = try decoder.decode([CardData].self, from: data)
                DispatchQueue.main.async {
                    self.favorites = decodedFavorites
                    print("Favoris décodés:", decodedFavorites)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                    print("Erreur de décodage:", error.localizedDescription)
                }
            }
        }.resume()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
