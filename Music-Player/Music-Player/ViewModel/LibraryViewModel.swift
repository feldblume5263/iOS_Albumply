//
//  LibraryAlbumsViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import MediaPlayer

class LibraryViewModel: ObservableObject {
    
    private var albumsItemCollection: [MPMediaItemCollection]?
    @Published var albums = [Album]()
    
    func getAlbum(at index: Int) -> Album {
        if index < 0 || index >= albums.count {
            return Album(title: AppString.undefinedString, artist: AppString.undefinedString, artwork: UIImage())
        }
        return albums[index]
    }
    
    func refreshAlbums() {
        self.makeAlbumsQuery()
        self.setAlbums()
    }
    
    func testRefreshAlbums() {
        self.makeAlbumsQuery()
        self.setAlbums()
    }
    
    private func setAlbums() {
        albums.removeAll()
        albumsItemCollection?.forEach({ libraryAlbumItemCollection in
            let libraryAlbumRepresentativeItem = libraryAlbumItemCollection.representativeItem
            let newAlbumTitle = libraryAlbumRepresentativeItem?.albumTitle ?? AppString.undefinedString
            let newAlbumArtist = libraryAlbumRepresentativeItem?.albumArtist ?? AppString.undefinedString
            let newAlbumArtwork = libraryAlbumRepresentativeItem?.artwork?.image(at: CGSize(width: 500, height: 500)) ?? UIImage()
            let newLibraryAlbum = Album(title: newAlbumTitle, artist: newAlbumArtist, artwork: newAlbumArtwork)
            albums.append(newLibraryAlbum)
        })
    }
    
    private func makeAlbumsQuery() {
        if let collections = MPMediaQuery.albums().collections {
            self.albumsItemCollection = collections
        } else {
            self.albumsItemCollection = nil
        }
    }
    
    func getAlbumsCount() -> Int {
        return albums.count
    }
}
