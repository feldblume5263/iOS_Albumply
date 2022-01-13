//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI

struct LibraryView: View {
    
    var body: some View {
        LibraryAlbumsGridView()
    }
}


// swipe해서 refresh 하기
struct LibraryAlbumsGridView: View {
    
    @ObservedObject var libraryAlbumsViewModel = LibraryAlbumsViewModel()
    
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 20, alignment: .center),
                               GridItem(.flexible(), spacing: 20, alignment: .center)]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    ForEach(0 ..< libraryAlbumsViewModel.getLibraryAlbumsCount(), id: \.self) { libraryAlbumIndex in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .shadow(radius: 3)
                                .frame(minHeight: 100, idealHeight: 200, maxHeight: 350, alignment: .center)
                            VStack{
                                Image(uiImage: libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumArtwork)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                VStack {
                                    Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumTitle)
                                        .font(libraryAlbumTitleFont)
                                        .foregroundColor(libraryAlbumTitleFontColor)
                                        .lineLimit(1)
                                    Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumArtist)
                                        .font(libraryAlbumArtistFont)
                                        .foregroundColor(libraryAlbumArtistFontColor)
                                        .lineLimit(1)
                                }
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                            }
                            .cornerRadius(20)
                        }
                        .padding(5)
                    }
                }
                .navigationTitle("라이브러리")
            }
            .onAppear(perform: libraryAlbumsViewModel.refreshLibraryAlbums)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
        }
    }
}


