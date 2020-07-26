import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @ObservedObject var photosFetcher = FlickrNetworkManager()
    @State private var pageSize = 0
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $searchText, placeholder: "Search for images...", onTextChanged: { searchText in
                    self.searchPhotos(for: searchText, page: self.pageSize)
                })
                if photosFetcher.photos.isEmpty {
                    Spacer()
                    Text("Search for images above")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                } else {
                    List() {
                        ForEach(photosFetcher.photos, id: \.id) { photo in
                            FlickrImageView(photo: photo)
                                .onAppear {
                                    self.getNextPageIfNeeded(id: photo.id)
                                }
                        }
                    }
                }
            }
            .navigationBarTitle("Flickr", displayMode: .inline)
        }
    }
    
    private func searchPhotos(for searchText: String, page: Int) {
        if !searchText.isEmpty, searchText.count > 3 {
            photosFetcher.searchImages(for: searchText)
        } else {
            photosFetcher.photos = []
        }
    }
    
    private func getNextPageIfNeeded(id: String) {
        guard photosFetcher.photos.last?.id == id else {
            return
        }
        pageSize += 1
        photosFetcher.appendImagesList(for: searchText, page: pageSize)
    }
}
