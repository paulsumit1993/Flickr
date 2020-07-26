import SwiftUI
import URLImage

struct FlickrImageView: View {
    let photo: FlickrPhoto
    private var imageURL: URL {
        if let url = Endpoint.imageDownload(farm: photo.farm,
                                      server: photo.server,
                                      id: photo.id,
                                      secret: photo.secret).url {
            return url
        } else {
            preconditionFailure("Image URL could not be constructed.")
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            URLImage(imageURL,
                     processors: [Resize(size: CGSize(width: 100.0, height: 100.0),
                                         scale: UIScreen.main.scale)],
                     content: {
                        $0.image
                            .resizable()
                            .overlay(Color.init(white: 0.3).opacity(0.5))
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fill)
            })
            VStack {
                Spacer()
                Text(photo.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(nil)
            }
            .padding(20)
        }
    }
}
