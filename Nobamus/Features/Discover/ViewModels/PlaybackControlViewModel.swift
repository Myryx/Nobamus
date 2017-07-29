import Foundation
import UIKit

protocol PlaybackControlViewModelProtocol {
    var image: UIImage? { get set }
    var title: String { get set }
}

class PlaybackControlViewModel: PlaybackControlViewModelProtocol {
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
}
    
