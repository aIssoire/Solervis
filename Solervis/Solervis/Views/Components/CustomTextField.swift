import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var imageName: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.orange)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.orange)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.orange)
            }
        }
    }
}
