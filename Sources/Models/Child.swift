import Foundation

struct Child: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var birthDate: Date
    var photoFilename: String?
}
