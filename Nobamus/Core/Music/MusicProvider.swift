//
//  Plays tracks
//

import Foundation
import StoreKit
import MediaPlayer

class MusicProvider {
    static var currentTrack: Track?
    static let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer()
    static func playTrack(_ track: Track) {
        systemMusicPlayer.setQueueWithStoreIDs([String(track.id)])
        systemMusicPlayer.play()
    }
}
