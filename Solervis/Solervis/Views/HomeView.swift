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
        let urlString = selectedSegment == "Offres" ? "https://solervis.fr/api/ads/connectedSupply/offer" : "https://solervis.fr/api/ads/connectedSupply/ask"
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
                    if selectedSegment == "Offres" {
                        offers = cardData
                    } else {
                        requests = cardData
                    }
                    print("Data received and decoded successfully")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
