import SwiftUI

struct AdDetailView: View {
    let item: CardData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Image section
                ZStack(alignment: .topLeading) {
                    TabView {
                        ForEach(item.data.picture, id: \.self) { uri in
                            if let url = URL(string: uri) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 300)
                                .clipped()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()
                }

                VStack(alignment: .leading, spacing: 16) {
                    // Title and location
                    Text(item.title)
                        .font(.title)
                        .bold()

                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                        Text(item.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Description
                    Text(item.data.adDescription)
                        .font(.body)

                    // Price and buy button
                    HStack {
                        HStack {
                            Text("\(item.price)")
                                .font(.title)
                                .bold()
                            Image(systemName: "centsign.circle")
                        }

                        Spacer()

                        Button(action: {
                            // Action d'achat
                        }) {
                            Text("Acheter")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }

                    Divider()

                    // Profile section
                    HStack {
                        if let url = URL(string: item.userImageURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                        }

                        VStack(alignment: .leading) {
                            Text(item.userName)
                                .font(.headline)

                            HStack {
                                ForEach(0..<5) { star in
                                    Image(systemName: star < Int(item.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }

                        Spacer()

                        Button(action: {
                            // Action de contact
                        }) {
                            Text("Contacter")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

struct AdDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let profile = CardData.Data.Profile(profilePicturePath: "https://example.com/profile.jpg", name: "Nom_de_Profil")
        let data = CardData.Data(profile: profile, id: "1", adTitle: "Aménagement extérieur", adDescription: "Une description de l’annonce...", adPrice: 100, adLocation: "Paris", picture: ["https://example.com/image1.jpg"], userId: "1", popularity: 0, userRating: 4.5)
        let item = CardData(data: data, categoryName: nil, isFavorite: nil)
        AdDetailView(item: item)
    }
}
