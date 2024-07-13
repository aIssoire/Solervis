import SwiftUI

struct RequestFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var city: String = ""
    @State private var address: String = ""
    @State private var postalCode: String = ""
    @State private var price: String = ""
    @State private var isNegotiable: Bool = false
    @State private var boost: Bool = false

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
                Text("Demande")
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
                        
                        TextField("Catégorie *", text: $category)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Localisation *")
                            .font(.headline)
                        
                        HStack {
                            TextField("Adresse", text: $address)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Image(systemName: "mappin.and.ellipse")
                        }
                        
                        HStack {
                            TextField("Code Postal", text: $postalCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        TextField("Ville *", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Prix *", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Toggle(isOn: $isNegotiable) {
                            Text("Négociable")
                        }
                        
                        HStack {
                            Text("Booster l'annonce")
                            Spacer()
                            Toggle("", isOn: $boost)
                                .labelsHidden()
                        }
                    }

                    Button(action: {
                        // Action pour soumettre le formulaire
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
}

struct RequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        RequestFormView()
    }
}
