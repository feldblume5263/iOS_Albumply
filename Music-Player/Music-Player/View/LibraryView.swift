//
//  LibraryView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/14.
//

import SwiftUI
import MediaPlayer

struct LibraryView: View {
    
    @ObservedObject var libraryViewModel = LibraryViewModel()
    @Binding var songQueue: [MPMediaItem]?
    @State var isAlbumDetailViewDisplaying = false
    
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 20, alignment: .center),
                               GridItem(.flexible(), spacing: 20, alignment: .center)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(0 ..< libraryViewModel.getAlbumsCount(), id: \.self) { index in
                    //libraryViewModel.getAlbum(at: index)
                    NavigationLink(destination: AlbumDetailView(album: libraryViewModel.albums[index], isViewDisplaying: $isAlbumDetailViewDisplaying, songQueue: $songQueue)) {
                        
                        makeGridAlbumItem(index: index)
                    }
                }
            }
            .navigationTitle("라이브러리")
            Button("Refresh Test") {
                libraryViewModel.testRefreshAlbums()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        .onAppear {
            if !isAlbumDetailViewDisplaying {
                libraryViewModel.refreshAlbums()
            }
        }
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
            Image(uiImage: libraryViewModel.getAlbum(at: index).albumArtwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            VStack {
                // MARK: - index로 받아오기 (try, catch)
                Text(libraryViewModel.getAlbum(at: index).albumTitle)
                    .font(libraryAlbumTitleFont)
                    .foregroundColor(libraryAlbumTitleFontColor)
                    .lineLimit(1)
                Text(libraryViewModel.getAlbum(at: index).albumArtist)
                    .font(libraryAlbumArtistFont)
                    .foregroundColor(libraryAlbumArtistFontColor)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
        }
        .cornerRadius(20)
    }
}
