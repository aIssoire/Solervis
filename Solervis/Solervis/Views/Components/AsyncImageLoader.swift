import SwiftUI

struct AsyncImageLoader: View {
    let url: URL?
    
    @State private var imageData: Data?
    
    var body: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Color.gray
                .onAppear {
                    fetchImage()
                }
        }
    }
    
    private func fetchImage() {
        guard let url = url else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String], let imageUrlString = json.first, let imageUrl = URL(string: imageUrlString) {
                self.fetchActualImage(from: imageUrl)
            } else if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            } else {
                print("Failed to convert data to UIImage")
            }
        }.resume()
    }
    
    private func fetchActualImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching actual image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            } else {
                print("Failed to convert actual image data to UIImage")
            }
        }.resume()
    }
}
