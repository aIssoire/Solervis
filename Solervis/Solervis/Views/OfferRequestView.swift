import SwiftUI

struct OfferRequestView: View {
    @Environment(\.presentationMode) var presentationMode
    var isOffer: Bool
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var availabilityDate: String = ""
    @State private var duration: String = ""
    @State private var city: String = ""
    @State private var address: String = ""
    @State private var postalCode: String = ""
    @State private var price: String = ""
    @State private var negotiable: Bool = false

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
                Text(isOffer ? "Offre" : "Demande")
                    .font(.title2)
                    .bold()
                Spacer()
                // Place an empty view to balance the layout
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding()

            ScrollView {
                VStack(spacing: 16) {
                    Group {
                        TextField("Titre *", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Description *", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Catégorie *", text: $category)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Group {
                        TextField("Disponibilités", text: $availabilityDate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Durée", text: $duration)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Ville *", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Adresse", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        TextField("Code postal", text: $postalCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Group {
                        TextField("Prix *", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Toggle(isOn: $negotiable) {
                            Text("Négociable")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        // Action pour booster l'annonce
                    }) {
                        Text("Booster l’annonce")
                            .padding(12)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        // Action pour déposer l'annonce
                        submitAd()
                    }) {
                        Text("Déposer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func submitAd() {
        // Construire le dictionnaire de données de l'annonce
        let adData: [String: Any] = [
            "title": title,
            "description": description,
            "category": category,
            "availabilityDate": availabilityDate,
            "duration": duration,
            "city": city,
            "address": address,
            "postalCode": postalCode,
            "price": price,
            "negotiable": negotiable,
            "isOffer": isOffer
        ]
        
        guard let url = URL(string: "https://solervis.fr/api/ad/create") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: adData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erreur de création des données JSON: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur de requête: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Données non reçues.")
                return
            }
            
            print("Réponse: \(String(data: data, encoding: .utf8) ?? "Impossible de convertir les données en chaîne")")
        }.resume()
    }
}

struct OfferRequestView_Previews: PreviewProvider {
    static var previews: some View {
        OfferRequestView(isOffer: true)
    }
}
