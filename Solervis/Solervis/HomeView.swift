import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String?
    @State private var selectedSegment: String = "Offres"
    
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
                
                Spacer()
                
                // Contenu de la page d'accueil à afficher selon le segment sélectionné
                if selectedSegment == "Offres" {
                    Text("Affichage des offres")
                    // Remplacez par le contenu des offres
                } else {
                    Text("Affichage des demandes")
                    // Remplacez par le contenu des demandes
                }
                
                Spacer()
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// Exemple de données pour les offres et demandes
let sampleOffers = ["Cours d'anglais", "Bricolage", "Jardinage"]
let sampleRequests = ["Réparation de vélo", "Cours de piano", "Aide déménagement"]
