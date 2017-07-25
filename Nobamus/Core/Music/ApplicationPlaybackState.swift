//
//  ApplicationPlaybackState.swift
//  Nobamus

import Foundation
import CoreMedia

enum PlayedLastTime {
    case inApp
    case inMusicApp
}

struct ApplicationPlaybackState {
    var track: Track? // currently/last time playing/played track
    var playbackTime: Double // time at which the track is currently playing or been played last time
    var isPlaying: Bool
    var isInForeground: Bool
    var wherePlayedLastTime: PlayedLastTime
}
