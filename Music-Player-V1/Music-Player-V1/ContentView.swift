//
//  ContentView.swift
//  Music-Player-V1
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

// 라이브러리 앨범 긁어서 반환
func getLibraryAlbums() -> [MPMediaItemCollection]? {
    guard let libraryAlbums = MPMediaQuery.albums().collections
    else { return nil }
    return libraryAlbums
}


struct ContentView: View {
    
    @State var albumsCount: Int = 0
    
    var body: some View {
        NavigationView {
            LibraryAlbumsView()
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
    private func setAlbumsCount() {
        if let albums = MPMediaQuery.albums().collections {
            albumsCount = albums.count
        }
    }
}


struct LibraryAlbumsView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0 ... 100, id: \.self) { _ in
                    Color.orange
                        .padding()
                }
            }.navigationTitle("라이브러리")
        }
    }
}

