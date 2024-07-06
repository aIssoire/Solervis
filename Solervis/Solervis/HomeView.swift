import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String?
    
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
                
                // Ajoute ici le contenu de la page d'accueil
                List {
                    // Exemple de contenu filtré par la recherche
                    ForEach(sampleData.filter { searchText.isEmpty ? true : $0.lowercased().contains(searchText.lowercased()) }, id: \.self) { item in
                        Text(item)
                    }
                }
                .navigationTitle("Accueil")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// Exemple de données pour la liste
let sampleData = ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]
