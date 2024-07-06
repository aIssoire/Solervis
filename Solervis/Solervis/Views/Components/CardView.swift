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
                AsyncImage(url: URL(string: userImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(userName)
                        .font(.headline)
                    HStack {
                        Text("\(rating)")
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
            
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(height: 150)
            .cornerRadius(10)
            
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
            imageURL: "https://example.com/image.jpg",
            title: "Cours d'anglais",
            location: "Colombes",
            price: 42,
            userName: "Issoire A.",
            userImageURL: "https://example.com/user.jpg",
            rating: 5
        )
        .previewLayout(.sizeThatFits)
    }
}
