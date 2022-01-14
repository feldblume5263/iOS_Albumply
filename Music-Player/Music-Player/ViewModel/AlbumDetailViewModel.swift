//
//  AlbumDetailViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/14.
//

import MediaPlayer

class AlbumDetailViewModel: ObservableObject {
    
    @Published var inAlbum: AlbumContents?
    
    func allSongsPlayButtonPressed() -> PlayingSong {
        if getSongsCount() > 0 {
            return PlayingSong(title: inAlbum?.songs[0].title ?? "", artist: inAlbum?.songs[0].artist ?? "", artWorkImage: UIImage())
        } else {
            return PlayingSong(title: "", artist: "", artWorkImage: UIImage())
        }
    }
    
    func setSongsInAlbumDetail(albumTitle: String) {
        inAlbum = AlbumContents(songs: getSongsFor(Album: albumTitle))
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
        return inAlbum?.songs.count ?? 0
    }
}
