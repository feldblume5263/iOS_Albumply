//
//  AlbumDetailView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer
import AVFoundation


struct SongsInAlbum {
    var songs: [MPMediaItem] = []
    var playStartingIndex: Int = 0
}


class AlbumDetailViewModel: ObservableObject {
    
    @Published var songsInAlbum: SongsInAlbum?
    
    func setSongsInAlbum(albumTitle: String) {
        let songs = getSongsIn(Album: albumTitle)
        songsInAlbum = SongsInAlbum(songs: songs)
    }
    
    private func getSongsIn(Album: String) -> [MPMediaItem] {
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
        return songsInAlbum?.songs.count ?? 0
    }
}

struct AlbumDetailView: View {
    
    @Binding var album: LibraryAlbumModel
    @ObservedObject var albumDetail = AlbumDetailViewModel()
    
    var body: some View {
        Text("\(album.albumTitle)")
        Text("\(album.albumArtist)")
        HStack {
            Button {
                
            } label: {
                Image(systemName: "play.fill")
            }
            .padding()
            Button {
                
            } label: {
                Image(systemName: "arrow.left.arrow.right")
            }
            .padding()
            
        }
        List {
            ForEach(0 ..< albumDetail.getSongsCount(), id: \.self) { songIndex in
                HStack {
                    Text("\(songIndex + 1)")
                        .frame(minWidth: 10, idealWidth: 15, maxWidth: 30)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    Text(albumDetail.songsInAlbum?.songs[songIndex].title ?? undefinedString)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
        }
        .onAppear(perform: initSongsInAlbum)
    }
    
    func initSongsInAlbum() {
        albumDetail.setSongsInAlbum(albumTitle: album.albumTitle)
    }
}

