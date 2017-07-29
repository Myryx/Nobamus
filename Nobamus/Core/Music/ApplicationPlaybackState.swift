//
//  ApplicationPlaybackState.swift
//  Nobamus

import Foundation
import CoreMedia
import MediaPlayer

enum PlayedLastTime {
    case inApp
    case inMusicApp
}

struct ApplicationPlaybackState {
    var playbackTime: Double // time at which the track is currently playing or been played last time
    var isPlaying: Bool
    var isInForeground: Bool
    var wherePlayedLastTime: PlayedLastTime
    var playbackItem: MPMediaItem?
}
