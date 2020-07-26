import Foundation

struct FlickrData: Decodable {
    let photos: Photo
}

struct Photo: Decodable {
    let photo: [FlickrPhoto]
}


public struct FlickrPhoto: Decodable, Identifiable {
    public let id: String
    public let title: String
    public let secret: String
    public let server: String
    public let farm: Int
}
