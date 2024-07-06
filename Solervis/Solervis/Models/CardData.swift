import Foundation

struct CardData: Identifiable, Decodable {
    var id: String { data.id }
    var imageURL: String { data.picture.first ?? "" }
    var title: String { data.adTitle }
    var location: String { data.adLocation }
    var price: Int { data.adPrice }
    var userName: String { data.profile.name }
    var userImageURL: String { data.profile.profilePicturePath ?? "" }
    var rating: Double { data.userRating }
    
    struct Data: Decodable {
        var profile: Profile
        var id: String
        var adTitle: String
        var adDescription: String
        var availabilityDate: String
        var availabilityDuration: String
        var adPrice: Int
        var adLocation: String
        var picture: [String]
        var userId: String
        var popularity: Int
        var isOffer: Bool
        var userRating: Double
        
        struct Profile: Decodable {
            var profilePicturePath: String?
            var name: String
            var firstname: String
        }
    }
    
    var data: Data
}
