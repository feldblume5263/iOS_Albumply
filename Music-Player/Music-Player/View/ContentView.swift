//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            LibraryAlbumsView()
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
        }
    }
}


struct LibraryAlbumsView: View {
    
    @ObservedObject var libraryAlbumsViewModel = LibraryAlbumsViewModel()
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        ScrollView {
            Button("test button") {
                libraryAlbumsViewModel.changeDataForTest()
            }
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(0 ..< libraryAlbumsViewModel.getLibraryAlbumsCount(), id: \.self) { libraryAlbumIndex in
                    VStack {
                        Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumTitle)
                            .font(libraryAlbumTitleFont)
                            .foregroundColor(libraryAlbumTitleFontColor)
                        Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumArtist)
                            .font(libraryAlbumArtistFont)
                            .foregroundColor(libraryAlbumArtistFontColor)
                    }
                }.background(Color.green)
            }
            .navigationTitle("라이브러리")
        }.onAppear(perform: libraryAlbumsViewModel.refreshLibraryAlbums)
    }
}

