import SwiftUI
import PhotosUI

struct AddView: View {
    @State private var selectedImages: [UIImage] = Array(repeating: UIImage(systemName: "plus")!, count: 6)
    @State private var isOffer: Bool = false
    @State private var isDemand: Bool = false
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImageIndex: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                Text("Ajouter")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 16) {
                        Text("Photos")
                            .font(.title2)
                            .bold()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            ForEach(0..<6) { index in
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .frame(width: 100, height: 150)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .onTapGesture {
                                        self.selectedImageIndex = index
                                        self.showImagePicker = true
                                    }
                            }
                        }
                        Text("Principale *")
                            .font(.caption)
                            .foregroundColor(.orange)
                        
                        Text("* champ requis")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 20) {
                        NavigationLink(destination: OfferFormView(isOffer: true, selectedImages: selectedImages), isActive: $isOffer) {
                            Button(action: {
                                if selectedImages.contains(where: { $0 != UIImage(systemName: "plus")! }) {
                                    isOffer = true
                                } else {
                                    print("Veuillez sélectionner au moins une image")
                                }
                            }) {
                                Text("Offre")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        }
                        
                        Text("ou")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: RequestFormView(isOffer: false, selectedImages: selectedImages), isActive: $isDemand) {
                            Button(action: {
                                if selectedImages.contains(where: { $0 != UIImage(systemName: "plus")! }) {
                                    isDemand = true
                                } else {
                                    print("Veuillez sélectionner au moins une image")
                                }
                            }) {
                                Text("Demande")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImages[selectedImageIndex], sourceType: self.imagePickerSourceType)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
