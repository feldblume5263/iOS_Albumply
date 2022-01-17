//
//  PlayerViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/16.
//

import SwiftUI
import MediaPlayer
import Combine

enum RepeatMode: CaseIterable {
    case noRepeat
    case albumRepeat
    case oneSongRepeat
}

class MiniPlayerViewModel: ObservableObject {
    @Published var nowPlayingSong = NowPlayingSong(title: "", albumTitle: "", artist: "", artWork: UIImage(), totalRate: 1.0)
    @Published var playbackState: MPMusicPlaybackState? = MPMusicPlayerController.applicationMusicPlayer.playbackState
    @Published var repeatMode: RepeatMode = .noRepeat
    @Published var isShuffle: Bool = false
//    let currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .current, mode: .default)
//    var cancellable: AnyCancellable?
//
//
//    init() {
//        DispatchQueue.global(qos: .background).async {
//            self.cancellable = self.currentTimePublisher.connect() as? AnyCancellable
//        }
//    }
//
//    deinit {
//        self.cancellable?.cancel()
//    }
    
    func changeRepeatMode() -> MPMusicRepeatMode {
        repeatMode = repeatMode.next()
        switch repeatMode {
        case .noRepeat:
            return MPMusicRepeatMode.none
        case .albumRepeat:
            return MPMusicRepeatMode.all
        case .oneSongRepeat:
            return MPMusicRepeatMode.one
        }
    }
    
    func makeNowPlayingSong(title: String?, albumeTitle: String?, artist: String?, artWork: MPMediaItemArtwork?, totalRate: Double?) {
        self.nowPlayingSong.title = title ?? ""
        self.nowPlayingSong.albumTitle = albumeTitle ?? ""
        self.nowPlayingSong.artist = artist ?? ""
        self.nowPlayingSong.artWork = artWork?.image(at: CGSize(width: 500, height: 500)) ?? UIImage(named: "emptyAlbum") ?? UIImage()
        self.nowPlayingSong.totalRate = totalRate ?? 10.0
    }
    
    func getTimeFrom(rawValue: Double, timeLeftMode: Bool) -> String {
        
        
        let hour = (Int(rawValue) % 86400) / 3600
        let minute = (Int(rawValue) % 3600) / 60
        let second = (Int(rawValue) % 3600) % 60
        
        if hour > 0 {
            return (timeLeftMode ? "-" : "") + String(format: "%02d", hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
        } else {
            return (timeLeftMode ? "-" : "") + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
        }
    }
}
