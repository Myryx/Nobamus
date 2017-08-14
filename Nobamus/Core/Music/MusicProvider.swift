//
//  Plays tracks
//

import Foundation
import StoreKit
import MediaPlayer

public let DiscoverTrackUpdatedNotificationName = "TrackHasBeenUpdated"

protocol MusicProviderDelegate {
    func personalTrackHasBeenUpdated(to track: Track)
    func discoverTrackHasEnded()
}

class MusicProvider {
    static var currentDiscoverTrack: Track?
    static var currentPersonalTrack: Track?
    static var playbackState = ApplicationPlaybackState(playbackTime: 0, isPlaying: false, isInForeground: true, wherePlayedLastTime: .inApp, playbackItem: nil)
    static var musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    static var delegate: MusicProviderDelegate?
    static var item: MPMediaItem?
    
    private static var silentPlayer: AVPlayer?
    
    static var isPlaying: Bool {
        return playbackState.isPlaying
    }
    
    static func setup() {
        musicPlayer.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicProvider.trackHasChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicProvider.playerPlaybackHasChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        
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
        musicPlayer.setQueueWithStoreIDs([String(track.id)])
        musicPlayer.play()
        currentDiscoverTrack = track
        playbackState.isPlaying = true
        guard let currentAudioItem = musicPlayer.nowPlayingItem else { return }
        MusicProvider.playbackState.playbackItem = currentAudioItem
    }
    
    static func playLastDiscoverTrack() {
        if let discoverTrack = currentDiscoverTrack {
            playTrack(discoverTrack)
        }
    }
    
    static func continuePlaying() {
        playbackState.isPlaying = true
        musicPlayer.play()
        playbackState.wherePlayedLastTime = .inApp
    }
    
    static func pausePlaying() {
        musicPlayer.pause()
        playbackState.isPlaying = false
        playbackState.playbackTime = MusicProvider.musicPlayer.currentPlaybackTime
        item = musicPlayer.nowPlayingItem
    }
    
    static func controlPlaybackPressed() {
        if isPlaying == true {
            pausePlaying()
        } else {
            continuePlaying()
        }
    }
    
    static func updatePersonalTrack() {
        guard let currentAudioItem = musicPlayer.nowPlayingItem else { return }
        guard let notificationTrack = TrackTranslator().translateFrom(mediaItem: currentAudioItem) else { return }
        if let currentPersonal = self.currentPersonalTrack { // if we played or playing anything at all
            if notificationTrack.title == currentPersonal.title { // still playing the track
                MusicProvider.playbackState.playbackTime = MusicProvider.musicPlayer.currentPlaybackTime
                MusicProvider.playbackState.isPlaying = MusicProvider.musicPlayer.playbackState == .playing
                MusicProvider.updatePlaybackInfo()
            }
        } else {
            currentPersonalTrack = notificationTrack
        }
        MusicProvider.playbackState.playbackItem = currentAudioItem
        if UIApplication.shared.applicationState == .background {
            playbackState.wherePlayedLastTime = .inMusicApp
        }
        delegate?.personalTrackHasBeenUpdated(to: notificationTrack)
    }
    
    static func updateDiscoverTrack() {
        guard UIApplication.shared.applicationState == .active else { return }
        guard let currentAudioItem = musicPlayer.nowPlayingItem else { return }
        MusicProvider.playbackState.playbackItem = currentAudioItem
        playbackState.wherePlayedLastTime = .inApp
        NotificationCenter.default.post(name: Notification.Name(rawValue: DiscoverTrackUpdatedNotificationName), object: nil)
        updatePlaybackInfo()
    }
    
    static func appIsAboutToGoBackground() {
        MusicProvider.playbackState.isInForeground = false
    }
    
    static func appIsAboutToGoForeground() {
        MusicProvider.playbackState.isInForeground = true
    }
    
    static func updatePlaybackInfo() {
        let playbackTime = MusicProvider.musicPlayer.currentPlaybackTime
        if playbackTime.isNaN == false {
            DatabaseManager.updatePlaybackInfo(playbackTime: playbackTime, isPlaying: MusicProvider.isPlaying)
        }
    }
    
    dynamic static func trackHasChanged(notification: Notification) {
        updatePersonalTrack()
        updateDiscoverTrack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if musicPlayer.playbackState == .stopped && playbackState.wherePlayedLastTime == .inApp && playbackState.isPlaying == false {
                delegate?.discoverTrackHasEnded()
            }
        }
    }
    
    dynamic static func playerPlaybackHasChanged(notification: Notification) {
//      here we observe how Native Music App affects our playback
        guard UIApplication.shared.applicationState == .background else { return }
        if musicPlayer.playbackState == .paused {
            playbackState.isPlaying = false
        } else {
            playbackState.isPlaying = true
        }
        updatePlaybackInfo()
    }
    
    dynamic static func silentDidReachEnd(notification: Notification) {
        MusicProvider.silentPlayer?.seek(to: kCMTimeZero)
        MusicProvider.silentPlayer?.play()
        updatePersonalTrack()
        updatePlaybackInfo()
    }
}
