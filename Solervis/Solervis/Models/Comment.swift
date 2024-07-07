import Foundation

struct Comment: Identifiable, Decodable {
    var id: String
    var date: String
    var comment: String
    var grade: Int
    var sender: Sender
    
    struct Sender: Decodable {
        var name: String
        var profilePicturePath: String
    }
}
