import SwiftUI

struct HomeView: View {
    let navigateTo: (AnyView, Bool) -> Void
    @State private var searchText: String = ""
    @State private var selectedCategory: String?
    @State private var selectedSegment: String = "Offres"
    @State private var offers: [CardData] = []
    @State private var requests: [CardData] = []
    @State private var ads: [CardData] = []
    
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
                                loadData(forCategory: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                if selectedCategory == nil {
                    HStack {
                        Spacer()
                        Button(action: {
                            selectedSegment = "Offres"
                            loadData()
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
                            loadData()
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
                }
                
                ScrollView {
                    VStack(spacing: 0) { // Remove spacing to avoid lines between cards
                        if selectedCategory == nil {
                            if selectedSegment == "Offres" {
                                ForEach(offers) { offer in
                                    Button(action: {
                                        navigateTo(AnyView(AdDetailView(item: offer)), true)
                                    }) {
                                        CardView(
                                            imageURL: offer.imageURL,
                                            title: offer.title,
                                            location: offer.location,
                                            price: offer.price,
                                            userName: offer.userName,
                                            userImageURL: offer.userImageURL,
                                            rating: offer.rating,
                                            isFavorite: offer.isFavorite ?? false,
                                            itemId: offer.id
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.vertical, 10) // Optional padding for better spacing
                                }
                            } else {
                                ForEach(requests) { request in
                                    Button(action: {
                                        navigateTo(AnyView(AdDetailView(item: request)), true)
                                    }) {
                                        CardView(
                                            imageURL: request.imageURL,
                                            title: request.title,
                                            location: request.location,
                                            price: request.price,
                                            userName: request.userName,
                                            userImageURL: request.userImageURL,
                                            rating: request.rating,
                                            isFavorite: request.isFavorite ?? false,
                                            itemId: request.id
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.vertical, 10) // Optional padding for better spacing
                                }
                            }
                        } else {
                            ForEach(ads) { ad in
                                Button(action: {
                                    navigateTo(AnyView(AdDetailView(item: ad)), true)
                                }) {
                                    CardView(
                                        imageURL: ad.imageURL,
                                        title: ad.title,
                                        location: ad.location,
                                        price: ad.price,
                                        userName: ad.userName,
                                        userImageURL: ad.userImageURL,
                                        rating: ad.rating,
                                        isFavorite: ad.isFavorite ?? false,
                                        itemId: ad.id
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.vertical, 10) // Optional padding for better spacing
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData(forCategory category: String? = nil) {
        var urlString: String
        if let category = category {
            urlString = "https://solervis.fr/api/ads/search/?query=\(category)"
        } else {
            urlString = selectedSegment == "Offres" ? "https://solervis.fr/api/ads/connectedSupply/offer" : "https://solervis.fr/api/ads/connectedSupply/ask"
        }
        guard let url = URL(string: urlString) else { return }
        
        print("Fetching data from: \(urlString)") // Journal
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let cardData = try JSONDecoder().decode([CardData].self, from: data)
                DispatchQueue.main.async {
                    if category == nil {
                        if selectedSegment == "Offres" {
                            offers = cardData
                        } else {
                            requests = cardData
                        }
                    } else {
                        ads = cardData
                    }
                    print("Data received and decoded successfully")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}
