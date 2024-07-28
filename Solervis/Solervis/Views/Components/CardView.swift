import SwiftUI

struct CardView: View {
    var imageURL: String
    var title: String
    var location: String
    var price: Int
    var userName: String
    var userImageURL: String
    var rating: Double
    @State var isFavorite: Bool
    var itemId: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(userImageURL)") {
                    AsyncImageLoader(url: url)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(userName)
                        .font(.headline)
                        .foregroundColor(.primary) // Fix text color to primary (black in light mode)
                    HStack {
                        Text(String(format: "%.1f", rating))
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: handleFavoriteClick) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(isFavorite ? .red : .primary)
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 5)

            if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(imageURL)") {
                AsyncImageLoader(url: url)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)  // Ensure image takes the full width
                    .clipped() // Ensure the image is clipped to fit the frame
            }

            Text(title)
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .foregroundColor(.primary) // Fix text color to primary (black in light mode)

            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text(location)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(price) ")
                    .foregroundColor(.primary) // Fix text color to primary (black in light mode)
                Image(systemName: "circle.fill")
                    .foregroundColor(.yellow)
            }
            .font(.subheadline)
            .padding([.horizontal, .bottom])
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }

    private func handleFavoriteClick() {
        let urlString = isFavorite
            ? "https://solervis.fr/api/user/favorite/\(itemId)"
            : "https://solervis.fr/api/user/favorite/"
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = isFavorite ? "DELETE" : "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !isFavorite {
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["adId": itemId])
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    // Handle error (e.g., show alert)
                }
                return
            }

            DispatchQueue.main.async {
                isFavorite.toggle()
                // Log analytics event if necessary
            }
        }.resume()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            imageURL: "File/6816-1718446755324.jpeg",
            title: "Cours d'anglais",
            location: "Colombes",
            price: 42,
            userName: "Issoire A.",
            userImageURL: "File/521588-1716550427743.jpeg",
            rating: 5,
            isFavorite: false,
            itemId: "1"
        )
        .previewLayout(.sizeThatFits)
    }
}
