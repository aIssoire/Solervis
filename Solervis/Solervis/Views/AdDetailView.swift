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
                            if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(uri)") {
                                AsyncImageLoader(url: url)
                                    .frame(width: UIScreen.main.bounds.width, height: 300)
                                    .clipped()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)

                    HStack {
                                            Button(action: {
                                                presentationMode.wrappedValue.dismiss()
                                            }) {
                                                Image(systemName: "xmark.circle")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(.black)
                                                    .background(Circle().fill(Color.white).frame(width: 40, height: 40))
                                            }
                                            .padding()

                                            Spacer()

                                            Button(action: {
                                                // Action de partage
                                                shareAd()
                                            }) {
                                                Image(systemName: "square.and.arrow.up")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.black)
                                                    .background(Circle().fill(Color.white).frame(width: 40, height: 40))
                                            }
                                            .padding()
                                        }
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
                            Image("coin_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
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
                        if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(item.userImageURL)") {
                            AsyncImageLoader(url: url)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
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
        .gesture(DragGesture().onEnded { value in
            if value.translation.width > 100 {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationBarHidden(true)
    }

    func shareAd() {
        guard let url = URL(string: "https://solervis.fr/ad/\(item.id)") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct AdDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let profile = CardData.Data.Profile(profilePicturePath: "File/521588-1716550427743.jpeg", name: "Nom_de_Profil")
        let data = CardData.Data(profile: profile, id: "1", adTitle: "Aménagement extérieur", adDescription: "Une description de l’annonce...", adPrice: 100, adLocation: "Paris", picture: ["File/6816-1718446755324.jpeg"], userId: "1", popularity: 0, userRating: 4.5)
        let item = CardData(data: data, categoryName: nil, isFavorite: nil)
        AdDetailView(item: item)
    }
}
