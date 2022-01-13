//
//  AlbumDetailView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI

struct AlbumDetailView: View {
    
    @Binding var album: LibraryAlbumModel
    
    var body: some View {
        Text("\(album.albumTitle)")
        Text("\(album.albumArtist)")
        List {
            ForEach(0 ..< album.albumSongs.count, id: \.self) { songIndex in
                HStack {
                    Text("\(songIndex + 1)")
                    Spacer()
                    Text(album.albumSongs[songIndex].title ?? undefinedString)
                }
            }
        }
    }
}

