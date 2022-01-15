//
//  AlbumDetailViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/14.
//

import MediaPlayer

class AlbumDetailViewModel: ObservableObject {
    @Published var albumContents: AlbumContents?
    @Published var songIDsQueue: [String] = []
    
    func setIDsQueue() {
        var stringQueue: [String] = []
        songIDsQueue.removeAll()
        albumContents?.songs.forEach({ song in
            stringQueue.append(song.playbackStoreID)
        })
        
        songIDsQueue = stringQueue
    }
    
    func setSongsInAlbumDetail(albumTitle: String) {
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
}
