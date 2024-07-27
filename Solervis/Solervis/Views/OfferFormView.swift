import SwiftUI

struct OfferFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var availabilityDate: Date = Date()
    @State private var availabilityDuration: Int = 1
    @State private var price: String = ""
    @State private var city: String = ""
    @State private var address: String = ""
    @State private var postalCode: String = ""
    @State private var isNegotiable: Bool = false
    @State private var isBoosted: Bool = false
    @State private var selectedImages: [UIImage] = []
    @State private var showingDatePicker = false
    @State private var showingDurationPicker = false
    let isOffer: Bool

    init(isOffer: Bool, selectedImages: [UIImage]) {
        self.isOffer = isOffer
        self._selectedImages = State(initialValue: selectedImages)
    }

    let categories = ["Animation", "Bricolage", "Covoiturage", "Cours particuliers", "Déménagement", "Fitness", "Jardinage", "Livraison", "Ménage", "Photographie", "Plomberie", "Réparation", "Services Informatiques", "Traiteur", "Autres"]

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
                Text("Offre")
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
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        TextField("Titre *", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Description *", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Picker("Catégorie *", selection: $category) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())

                        Button(action: {
                            showingDatePicker.toggle()
                        }) {
                            HStack {
                                Text("Disponibilités: \(availabilityDate, formatter: dateFormatter)")
                                Spacer()
                                Image(systemName: "calendar")
                            }
                        }
                        .sheet(isPresented: $showingDatePicker) {
                            DatePicker("Disponibilités", selection: $availabilityDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                        }

                        Button(action: {
                            showingDurationPicker.toggle()
                        }) {
                            HStack {
                                Text("Durée: \(availabilityDuration) heures")
                                Spacer()
                                Image(systemName: "clock")
                            }
                        }
                        .sheet(isPresented: $showingDurationPicker) {
                            VStack {
                                Text("Durée (heures)")
                                Picker("Durée (heures)", selection: $availabilityDuration) {
                                    ForEach(1..<25) { duration in
                                        Text("\(duration) heures").tag(duration)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .labelsHidden()
                                Button("OK") {
                                    showingDurationPicker.toggle()
                                }
                            }
                            .padding()
                        }

                        TextField("Ville *", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("Adresse", text: $address)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack {
                            TextField("Code Postal", text: $postalCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        TextField("Prix *", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Toggle(isOn: $isNegotiable) {
                            Text("Négociable")
                        }
                        
                        HStack {
                            Text("Booster l'annonce")
                            Spacer()
                            Toggle("", isOn: $isBoosted)
                                .labelsHidden()
                        }
                    }

                    Button(action: {
                        submitForm()
                    }) {
                        Text("Déposer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func submitForm() {
        guard let userId = UserDefaults.standard.string(forKey: "userId"),
              let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "https://solervis.fr/api/ads")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let formData = createFormData(boundary: boundary)
        request.httpBody = formData

        print("Form Data: \(String(data: formData, encoding: .utf8) ?? "Failed to convert form data to string")")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur de requête : \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Aucune donnée reçue")
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Réponse JSON : \(jsonResponse)")
            } catch {
                print("Erreur de décodage : \(error.localizedDescription)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response String: \(responseString)")
                }
            }
        }.resume()
    }

    func createFormData(boundary: String) -> Data {
        var body = Data()

        func append(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"title\"\r\n\r\n")
        append("\(title)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"description\"\r\n\r\n")
        append("\(description)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"price\"\r\n\r\n")
        append("\(price)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"isOffer\"\r\n\r\n")
        append("true\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"category\"\r\n\r\n")
        append("\(category)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"city\"\r\n\r\n")
        append("\(city)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"address\"\r\n\r\n")
        append("\(address)\r\n")
        
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"street\"\r\n\r\n")
        append("\(address)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"zipCode\"\r\n\r\n")
        append("\(postalCode)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"isBoosted\"\r\n\r\n")
        append("\(isBoosted)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"availabilityDate\"\r\n\r\n")
        append("\(availabilityDate)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"availabilityDuration\"\r\n\r\n")
        append("\(availabilityDuration)\r\n")

        for (index, image) in selectedImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                append("--\(boundary)\r\n")
                append("Content-Disposition: form-data; name=\"files\"; filename=\"image\(index).jpg\"\r\n")
                append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                append("\r\n")
            }
        }

        append("--\(boundary)--\r\n")

        // Impression du contenu de formData pour le débogage
        if let bodyString = String(data: body, encoding: .utf8) {
            print("Form Data: \(bodyString)")
        }

        return body
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}
