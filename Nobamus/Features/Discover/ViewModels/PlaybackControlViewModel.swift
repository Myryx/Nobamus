import Foundation
import UIKit

protocol PlaybackControlViewModelProtocol {
    var title: String { get set }
    var artist: String { get set }
}

class PlaybackControlViewModel: PlaybackControlViewModelProtocol {
    var title: String
    var artist: String
    
    init(title: String, artist: String) {
        self.title = title
        self.artist = artist
    }
}
    
