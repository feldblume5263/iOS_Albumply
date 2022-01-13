//
//  LibraryAlbumsViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer

class LibraryAlbumsViewModel: ObservableObject {
    
    private var libraryAlbumsItemCollection: [MPMediaItemCollection]?
    @Published var libraryAlbums = [LibraryAlbumModel]()
    
    func getLibraryAlbumByIndex(at index: Int) -> LibraryAlbumModel? {
        if index < 0 || index >= libraryAlbums.count {
//            throw runtimeError.outOfRange
            return nil
        }
        return libraryAlbums[index]
        
    }
    
    func refreshLibraryAlbums() {
        DispatchQueue.main.async {
            self.setLibraryAlbumsQuery()
            self.parseLibraryAlbums()
        }
    }
    
    private func parseLibraryAlbums() {
        libraryAlbums.removeAll()
        libraryAlbumsItemCollection?.forEach({ libraryAlbumItemCollection in
            let libraryAlbumRepresentativeItem = libraryAlbumItemCollection.representativeItem
            let newAlbumTitle = libraryAlbumRepresentativeItem?.albumTitle ?? undefinedString
            let newAlbumArtist = libraryAlbumRepresentativeItem?.albumArtist ?? undefinedString
            let newAlbumArtwork = libraryAlbumRepresentativeItem?.artwork?.image(at: CGSize(width: 500, height: 500)) ?? UIImage()
            let newAlbumSongs = getSongsIn(Album: newAlbumTitle)
            let newLibraryAlbum = LibraryAlbumModel(albumTitle: newAlbumTitle, albumArtist: newAlbumArtist, albumArtwork: newAlbumArtwork, albumSongs: newAlbumSongs)
            libraryAlbums.append(newLibraryAlbum)
        })
    }
    
    private func setLibraryAlbumsQuery() {
        if let libraryAlbums = MPMediaQuery.albums().collections {
            self.libraryAlbumsItemCollection = libraryAlbums
        } else {
            self.libraryAlbumsItemCollection = nil
        }
    }
    // 라이브러리 앨범 개수 반환
    func getLibraryAlbumsCount() -> Int {
        return libraryAlbums.count
    }
    
    private func getSongsIn(Album: String) -> [MPMediaItem] {
        //How to search for a particular album
        let albumTitleFilter = MPMediaPropertyPredicate(value: Album,
                                 forProperty: MPMediaItemPropertyAlbumTitle,
                                 comparisonType: .equalTo)
        
        if let collections = MPMediaQuery(filterPredicates: Set(arrayLiteral: albumTitleFilter)).items {
            return collections
        } else {
            return []
        }
    }
}
