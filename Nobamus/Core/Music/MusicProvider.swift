//
//  Plays tracks
//

import Foundation
import StoreKit
import MediaPlayer

protocol MusicProviderDelegate {
    func personalTrackHasChanged(to track: Track)
//    func discoverTrackHasChanged()
}

class MusicProvider {
    static var currentDiscoverTrack: Track?
    static var currentPersonalTrack: Track?
    static let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer()
    static let appMusicPlayer = MPMusicPlayerController.applicationMusicPlayer()
    static var delegate: MusicProviderDelegate?
    private static var silentPlayer: AVPlayer?
    
    static func setup() {
        MusicProvider.systemMusicPlayer.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicProvider.trackHasChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        setupSilentPlayer()
    }
    
    private static func setupSilentPlayer() {
        guard let filePath  = Bundle.main.path(forResource: "audioFile", ofType: "mp3") else { fatalError("Could not find the audio file") }
        let silentPlayer = AVPlayer(url: URL(fileURLWithPath: filePath))
        silentPlayer.isMuted = true
        silentPlayer.volume = 0.0
        silentPlayer.play()
        MusicProvider.silentPlayer = silentPlayer
        NotificationCenter.default.addObserver(self, selector:#selector(MusicProvider.silentDidReachEnd), name:.AVPlayerItemDidPlayToEndTime, object:nil)
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        }
        catch {}
    }
    
    static func playTrack(_ track: Track) {
        MusicProvider.appMusicPlayer.setQueueWithStoreIDs([String(track.id)])
        MusicProvider.appMusicPlayer.play()
        currentDiscoverTrack = track
    }
    
    private static func updatePersonalTrack() {
        guard let currentAudioItem = MusicProvider.systemMusicPlayer.nowPlayingItem,
        let currentPersonalTrack = TrackTranslator().translateFrom(mediaItem: currentAudioItem) else {
            return
        }
        delegate?.personalTrackHasChanged(to: currentPersonalTrack)
    }
    
    dynamic static func trackHasChanged(notification: Notification) {
        updatePersonalTrack()
    }
    
    dynamic static func silentDidReachEnd(notification: Notification) {
        MusicProvider.silentPlayer?.seek(to: kCMTimeZero)
        MusicProvider.silentPlayer?.play()
        updatePersonalTrack()
    }
}
