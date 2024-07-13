import SwiftUI
import UIKit

struct AddView: View {
    @State private var selectedImages: [UIImage] = Array(repeating: UIImage(systemName: "plus")!, count: 6)
    @State private var isOffer: Bool = false
    @State private var isDemand: Bool = false
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var currentImageIndex = 0

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
                                        currentImageIndex = index
                                        showingActionSheet = true
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
                        NavigationLink(destination: OfferFormView(), isActive: $isOffer) {
                            Button(action: {
                                isOffer = true
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
                        
                        NavigationLink(destination: RequestFormView(), isActive: $isDemand) {
                            Button(action: {
                                isDemand = true
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
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImages[currentImageIndex], sourceType: imagePickerSourceType)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Sélectionner une image"), message: Text("Choisissez une source"), buttons: [
                    .default(Text("Caméra")) {
                        imagePickerSourceType = .camera
                        showingImagePicker = true
                    },
                    .default(Text("Galerie")) {
                        imagePickerSourceType = .photoLibrary
                        showingImagePicker = true
                    },
                    .cancel()
                ])
            }
        }
    }
}
