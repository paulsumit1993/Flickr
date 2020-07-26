import Foundation

enum Endpoint {
    private static let baseURLString = "https://api.flickr.com/services/rest/"
    private static let apiKey = "062a6c0c49e4de1d78497d13a7dbb360"
    
    case imageList(searchText: String, perPage: String, page: String)
    case imageDownload(farm: Int, server: String, id: String, secret: String)
    
    var url: URL? {
        switch self {
        case .imageList(let searchText, let perPage, let page):
            let queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                              URLQueryItem(name: "api_key", value: Endpoint.apiKey),
                              URLQueryItem(name: "text", value: searchText),
                              URLQueryItem(name: "nojsoncallback", value: "1"),
                              URLQueryItem(name: "per_page", value: perPage),
                              URLQueryItem(name: "format", value: "json"),
                              URLQueryItem(name: "page", value: page)]
            var urlComponents = URLComponents(string: Endpoint.baseURLString)
            urlComponents?.queryItems = queryItems
            return urlComponents?.url
        case .imageDownload(let farm, let server, let id, let secret):
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
        }
    }
}

public class FlickrNetworkManager: ObservableObject {
    @Published var photos = [FlickrPhoto]()
    private let session = URLSession.shared
    
    func searchImages(for searchTerm: String, pageSize: Int = 10) {
        guard let url = Endpoint.imageList(searchText: searchTerm, perPage: "\(pageSize)", page: "\(0)").url else {
            return
        }
        fetch(with: url) { flickrPhotos in
            self.photos = flickrPhotos
        }
    }
    
    func appendImagesList(for searchTerm: String, page: Int, pageSize: Int = 10) {
        guard let url = Endpoint.imageList(searchText: searchTerm, perPage: "\(pageSize)", page: "\(page)").url else {
            return
        }
        fetch(with: url) { flickrPhotos in
            self.photos.append(contentsOf: flickrPhotos)
        }
    }
    
    private func fetch(with url: URL,
               completion: @escaping ([FlickrPhoto]) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let flickrData = try JSONDecoder().decode(FlickrData.self, from: data)
                    DispatchQueue.main.async {
                        completion(flickrData.photos.photo)
                    }
                } else {
                    completion([])
                    print("No Data")
                }
            } catch {
                // Should bubble the error up the stack in production environment.
                completion([])
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}
