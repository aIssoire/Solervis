import SwiftUI

struct CardView: View {
    var imageURL: String
    var title: String
    var location: String
    var price: Int
    var userName: String
    var userImageURL: String
    var rating: Double
    
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
                    HStack {
                        Text(String(format: "%.1f", rating))
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "heart")
            }
            .padding(.bottom, 5)
            
            if let url = URL(string: "https://solervis.fr/file/getFileBinary?path=\(imageURL)") {
                AsyncImageLoader(url: url)
                    .frame(height: 150)
                    .cornerRadius(10)
            }
            
            Text(title)
                .font(.title3)
                .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text(location)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(price) ")
                Image(systemName: "circle.fill")
                    .foregroundColor(.yellow)
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
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
            rating: 5
        )
        .previewLayout(.sizeThatFits)
    }
}
