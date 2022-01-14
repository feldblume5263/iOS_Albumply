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
    
    func getLibraryAlbum(at index: Int) -> LibraryAlbumModel {
        if index < 0 || index >= libraryAlbums.count {
            return LibraryAlbumModel(albumTitle: undefinedString, albumArtist: undefinedString, albumArtwork: UIImage())
        }
        return libraryAlbums[index]
    }
    
    func refreshLibraryAlbums() {
        self.setLibraryAlbumsQuery()
        self.parseLibraryAlbums()
    }
    
    private func parseLibraryAlbums() {
        libraryAlbums.removeAll()
        libraryAlbumsItemCollection?.forEach({ libraryAlbumItemCollection in
            let libraryAlbumRepresentativeItem = libraryAlbumItemCollection.representativeItem
            let newAlbumTitle = libraryAlbumRepresentativeItem?.albumTitle ?? undefinedString
            let newAlbumArtist = libraryAlbumRepresentativeItem?.albumArtist ?? undefinedString
            let newAlbumArtwork = libraryAlbumRepresentativeItem?.artwork?.image(at: CGSize(width: 500, height: 500)) ?? UIImage()
            let newLibraryAlbum = LibraryAlbumModel(albumTitle: newAlbumTitle, albumArtist: newAlbumArtist, albumArtwork: newAlbumArtwork)
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
}
