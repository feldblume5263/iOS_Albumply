//
//  PlayerViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/16.
//

import SwiftUI
import MediaPlayer
import Combine

final class MiniPlayerViewModel: ObservableObject {
    private(set) var player: MPMusicPlayerController
    @Published private(set) var nowPlayingSong = NowPlayingSong(title: "", albumTitle: "", artist: "", artWork: UIImage(), totalRate: 1.0)
    @Published var playbackState: MPMusicPlaybackState? = MPMusicPlayerController.applicationMusicPlayer.playbackState
    @Published var playerOption = PlayerOption()
    @Published var progressRate:Double = 0.0
    
    init(player: MPMusicPlayerController) {
        self.player = player
    }
    
    func initPlayerFromUserDefaults() {
        switch (UserDefaults.standard.integer(forKey: UserDefaultsKey.repeatDefault)) {
        case 0:
            player.repeatMode = .none
            playerOption.repeatMode = .noRepeat
        case 1:
            player.repeatMode = .all
            playerOption.repeatMode = .albumRepeat
        case 2:
            player.repeatMode = .one
            playerOption.repeatMode = .oneSongRepeat
        default:
            player.repeatMode = .none
            playerOption.repeatMode = .noRepeat
        }
        if (UserDefaults.standard.array(forKey: UserDefaultsKey.queueDefault) != nil) {
            player.setQueue(with: UserDefaults.standard.array(forKey: UserDefaultsKey.queueDefault) as? [String] ?? [String]())
            player.prepareToPlay()
            player.skipToBeginning()
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.shuffleDefault) {
            player.shuffleMode = MPMusicShuffleMode.songs
        }
    }
    
    func changeRepeatMode() -> MPMusicRepeatMode {
        playerOption.repeatMode = playerOption.repeatMode.next()
        switch playerOption.repeatMode {
        case .noRepeat:
            UserDefaults.standard.set(0, forKey: UserDefaultsKey.repeatDefault)
            return MPMusicRepeatMode.none
        case .albumRepeat:
            UserDefaults.standard.set(1, forKey: UserDefaultsKey.repeatDefault)
            return MPMusicRepeatMode.all
        case .oneSongRepeat:
            UserDefaults.standard.set(2, forKey: UserDefaultsKey.repeatDefault)
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
    
    static func getTimeFrom(rawValue: Double, timeLeftMode: Bool) -> String {
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
