import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String?
    @State private var selectedSegment: String = "Offres"
    @State private var offers: [CardData] = []
    @State private var requests: [CardData] = []
    
    let categories = ["Animation", "Bricolage", "Covoiturage", "Cours particuliers", "Déménagement", "Fitness", "Jardinage", "Livraison", "Ménage", "Photographie", "Plomberie", "Réparation", "Services Informatiques", "Traiteur", "Autres"]
    
    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(text: $searchText)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(category: category, isSelected: category == selectedCategory) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        selectedSegment = "Offres"
                    }) {
                        Text("OFFRES")
                            .foregroundColor(selectedSegment == "Offres" ? .black : .gray)
                            .fontWeight(selectedSegment == "Offres" ? .bold : .regular)
                            .padding(.bottom, 5)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedSegment == "Offres" ? .black : .clear),
                                alignment: .bottom
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedSegment = "Demandes"
                    }) {
                        Text("DEMANDES")
                            .foregroundColor(selectedSegment == "Demandes" ? .black : .gray)
                            .fontWeight(selectedSegment == "Demandes" ? .bold : .regular)
                            .padding(.bottom, 5)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedSegment == "Demandes" ? .black : .clear),
                                alignment: .bottom
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                List {
                    if selectedSegment == "Offres" {
                        ForEach(offers) { offer in
                            CardView(
                                imageURL: offer.imageURL,
                                title: offer.title,
                                location: offer.location,
                                price: offer.price,
                                userName: offer.userName,
                                userImageURL: offer.userImageURL,
                                rating: offer.rating
                            )
                        }
                    } else {
                        ForEach(requests) { request in
                            CardView(
                                imageURL: request.imageURL,
                                title: request.title,
                                location: request.location,
                                price: request.price,
                                userName: request.userName,
                                userImageURL: request.userImageURL,
                                rating: request.rating
                            )
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        // Remplacez par votre appel API pour charger les données
        // Exemple de données fictives
        offers = [
            CardData(imageURL: "https://example.com/image1.jpg", title: "Cours d'anglais", location: "Colombes", price: 42, userName: "Issoire A.", userImageURL: "https://example.com/user1.jpg", rating: 5),
            CardData(imageURL: "https://example.com/image2.jpg", title: "Bricolage", location: "Paris", price: 30, userName: "Jean B.", userImageURL: "https://example.com/user2.jpg", rating: 4)
        ]
        
        requests = [
            CardData(imageURL: "https://example.com/image3.jpg", title: "Réparation de vélo", location: "Lyon", price: 20, userName: "Marie C.", userImageURL: "https://example.com/user3.jpg", rating: 5),
            CardData(imageURL: "https://example.com/image4.jpg", title: "Cours de piano", location: "Marseille", price: 50, userName: "Paul D.", userImageURL: "https://example.com/user4.jpg", rating: 3)
        ]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CardData: Identifiable {
    var id = UUID()
    var imageURL: String
    var title: String
    var location: String
    var price: Int
    var userName: String
    var userImageURL: String
    var rating: Int
}
