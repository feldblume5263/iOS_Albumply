//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI

struct LibraryView: View {
    
    var miniPlayerView: some View = LibraryGridView()
    
    var body: some View {
        NavigationView {
            LibraryGridView()
        }
        Text("mini player")
    }
}


// MARK: - swipe해서 refresh, active될때 감지해서 refresh
struct LibraryGridView: View {
    
    @ObservedObject var libraryAlbumsViewModel = LibraryAlbumsViewModel()
    
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 20, alignment: .center),
                               GridItem(.flexible(), spacing: 20, alignment: .center)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(0 ..< libraryAlbumsViewModel.getLibraryAlbumsCount(), id: \.self) { index in
                    NavigationLink(destination: AlbumDetailView(album: $libraryAlbumsViewModel.libraryAlbums[index])) {
                        makeGridAlbumItem(index: index)
                    }
                }
            }
            .navigationTitle("라이브러리")
        }
        .onAppear(perform: libraryAlbumsViewModel.refreshLibraryAlbums)
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    private func makeGridAlbumItem(index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 3)
                .frame(minHeight: 100, idealHeight: 200, maxHeight: 350, alignment: .center)
            makeAlbumItemContents(index: index)
        }
        .padding(5)
    }
    
    private func makeAlbumItemContents(index: Int) -> some View {
        VStack{
            Image(uiImage: libraryAlbumsViewModel.getLibraryAlbum(at: index).albumArtwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            VStack {
                // MARK: - index로 받아오기 (try, catch)
                Text(libraryAlbumsViewModel.getLibraryAlbum(at: index).albumTitle)
                    .font(libraryAlbumTitleFont)
                    .foregroundColor(libraryAlbumTitleFontColor)
                    .lineLimit(1)
                Text(libraryAlbumsViewModel.getLibraryAlbum(at: index).albumArtist)
                    .font(libraryAlbumArtistFont)
                    .foregroundColor(libraryAlbumArtistFontColor)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
        }
        .cornerRadius(20)
    }
}


