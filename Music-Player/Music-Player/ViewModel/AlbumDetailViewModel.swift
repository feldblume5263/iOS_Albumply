//
//  AlbumDetailViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/14.
//

import MediaPlayer

class AlbumDetailViewModel: ObservableObject {
    
    @Published var inAlbum: AlbumContents?
    
    func allSongsPlayButtonPressed() -> [MPMediaItem]? {
        return inAlbum?.songs
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
