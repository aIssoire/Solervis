import SwiftUI

struct CategoryButton: View {
    var category: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(category: "Animation", isSelected: false, action: {})
            .previewLayout(.sizeThatFits)
    }
}
