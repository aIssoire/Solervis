import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Rechercher...", text: $text)
                .foregroundColor(.primary)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(20)
        }
        .padding(.horizontal, 10)
        .background(Color(.systemGray5))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
