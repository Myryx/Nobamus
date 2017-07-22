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
    
    static var isPlaying: Bool {
        return MusicProvider.systemMusicPlayer.playbackState == .playing
    }
    
    static func setup() {
        MusicProvider.systemMusicPlayer.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicProvider.trackHasChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        setupSilentPlayer()
    }
    
    private static func setupSilentPlayer() {
        guard let filePath  = Bundle.main.path(forResource: "silence", ofType: "mp3") else { fatalError("Could not find the audio file") }
        let silentPlayer = AVPlayer(url: URL(fileURLWithPath: filePath))
        silentPlayer.volume = 1.0
        MusicProvider.silentPlayer = silentPlayer
        silentPlayer.play()
        NotificationCenter.default.addObserver(self, selector:#selector(MusicProvider.silentDidReachEnd), name:.AVPlayerItemDidPlayToEndTime, object:nil)
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try audioSession.setActive(true)
        }
        catch {}
    }
    
    static func playTrack(_ track: Track) {
        MusicProvider.systemMusicPlayer.setQueueWithStoreIDs([String(track.id)])
        MusicProvider.systemMusicPlayer.play()
        currentDiscoverTrack = track
    }
    
    static func startPlaying() {
        MusicProvider.systemMusicPlayer.play()
    }
    
    static func stopPlaying() {
        MusicProvider.systemMusicPlayer.pause()
    }
    
    static func updatePersonalTrack() {
        guard let currentAudioItem = MusicProvider.systemMusicPlayer.nowPlayingItem else { return }
        guard let currentPersonalTrack = TrackTranslator().translateFrom(mediaItem: currentAudioItem) else { return }
//        print("CurrentItem: \(currentAudioItem.title!)")
//        print("CurrentItem: \(currentPersonalTrack)")
        delegate?.personalTrackHasChanged(to: currentPersonalTrack)
    }
    
    dynamic static func trackHasChanged(notification: Notification) {
        updatePersonalTrack()
    }
    
    dynamic static func silentDidReachEnd(notification: Notification) {
        MusicProvider.silentPlayer?.seek(to: kCMTimeZero)
        MusicProvider.silentPlayer?.play()
//        print("Did loop the silent track")
        updatePersonalTrack()
    }
}
