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
        
        print("Fetching image from URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                    print("Content-Type: \(contentType)")
                }
            }
            
            if let data = data {
                print("Image data received: \(data.count) bytes")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    if let imageUrlString = json.first, let imageUrl = URL(string: imageUrlString) {
                        print("Fetching actual image from URL: \(imageUrl)")
                        self.fetchActualImage(from: imageUrl)
                    }
                } else {
                    print("Received non-JSON data")
                    if let image = UIImage(data: data) {
                        print("Successfully converted data to UIImage")
                        DispatchQueue.main.async {
                            self.imageData = data
                        }
                    } else {
                        print("Failed to convert data to UIImage")
                    }
                }
            } else {
                print("No data received")
            }
        }.resume()
    }
    
    private func fetchActualImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching actual image: \(error)")
                return
            }
            
            if let data = data {
                print("Actual image data received: \(data.count) bytes")
                if let image = UIImage(data: data) {
                    print("Successfully converted actual image data to UIImage")
                    DispatchQueue.main.async {
                        self.imageData = data
                    }
                } else {
                    print("Failed to convert actual image data to UIImage")
                }
            } else {
                print("No actual image data received")
            }
        }.resume()
    }
}
