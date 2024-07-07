struct UserProfile: Codable {
    var id: String
    var address: String
    var city: String
    var description: String
    var email: String
    var favoriteAds: [String]
    var favoriteUsers: [String]
    var firstname: String
    var job: String
    var lastname: String
    var location: Location
    var nbRating: Int
    var nbReviewsSent: Int
    var notification: Bool
    var notificationRegle: NotificationRegle
    var passions: [String]
    var phoneNumber: Int
    var postalCode: String
    var profilePicturePath: String
    var rayons: Int
    var totalValueRating: Int
    var username: String
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}

struct NotificationRegle: Codable {
    var achat_email: Bool
    var commentaire_email: Bool
    var favorie_email: Bool
    var messages_email: Bool
    var recommendation_email: Bool
}
