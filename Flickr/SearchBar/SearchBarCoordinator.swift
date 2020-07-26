import Foundation
import SwiftUI

class Coordinator: NSObject, UISearchBarDelegate {
    var onTextChanged: (String) -> Void
    @Binding var text: String
    
    init(text: Binding<String>, onTextChanged: @escaping (String) -> Void) {
        _text = text
        self.onTextChanged = onTextChanged
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        text = searchText
        onTextChanged(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        text = ""
        onTextChanged(text)
    }
}
