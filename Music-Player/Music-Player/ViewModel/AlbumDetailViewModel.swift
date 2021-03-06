//
//  AlbumDetailViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/14.
//

import MediaPlayer

final class AlbumDetailViewModel: ObservableObject {
    
    private var player: MPMusicPlayerController
    private(set) var album: Album
    @Published private(set) var albumContents: AlbumContents?
    @Published private var songIDsQueue: [String] = []
    @Published private(set) var waitingForPrepare: Bool = false
    
    init(album: Album, player: MPMusicPlayerController) {
        self.album = album
        self.player = player
        initSongsInAlbum()
        setIDsQueue()
    }
    
    private func initSongsInAlbum() {
        setSongsInAlbumDetail(albumTitle: album.title)
    }

    private func setIDsQueue() {
        var stringQueue: [String] = []
        songIDsQueue.removeAll()
        albumContents?.songs.forEach({ song in
            stringQueue.append(song.playbackStoreID)
        })
        
        songIDsQueue = stringQueue
    }
    
    private func setSongsInAlbumDetail(albumTitle: String) {
        albumContents = AlbumContents(songs: getSongsFor(Album: albumTitle))
    }
    
    private func getSongsFor(Album: String) -> [MPMediaItem] {
        let albumTitleFilter = MPMediaPropertyPredicate(value: Album,
                                                        forProperty: MPMediaItemPropertyAlbumTitle,
                                                        comparisonType: .equalTo)
        
        if let collections = MPMediaQuery(filterPredicates: Set(arrayLiteral: albumTitleFilter)).items {
            return collections
        } else {
            return []
        }
    }
    
    func getSongsCount() -> Int {
        return albumContents?.songs.count ?? 0
    }
    
    func allSongsPlayButtonPressed(isShuffle: Bool) {
        waitingForPrepare = true
        player.stop()
        player.setQueue(with: songIDsQueue)
        UserDefaults.standard.set(songIDsQueue, forKey: UserDefaultsKey.queueDefault)
        if isShuffle {
            player.shuffleMode = MPMusicShuffleMode.songs
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.shuffleDefault)
            player.shuffleMode = MPMusicShuffleMode.songs
        } else {
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.shuffleDefault)
            player.shuffleMode = MPMusicShuffleMode.off
        }
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.waitingForPrepare = false
        }
    }
    
    func specificSongPlayButtonPressed(songIndex: Int) {
        waitingForPrepare = true
        player.stop()
        player.setQueue(with: songIDsQueue)
        UserDefaults.standard.set(songIDsQueue, forKey: UserDefaultsKey.queueDefault)
        player.play()
        player.nowPlayingItem = albumContents?.songs[songIndex]
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.shuffleDefault)
        player.shuffleMode = MPMusicShuffleMode.off
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.waitingForPrepare = false
        }
    }
}
