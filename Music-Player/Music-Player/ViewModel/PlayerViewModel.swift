//
//  PlayerViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/16.
//

import SwiftUI
import MediaPlayer

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
}
