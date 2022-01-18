//
//  LibraryView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/14.
//

import SwiftUI
import MediaPlayer

struct LibraryView: View {
    @StateObject fileprivate var libraryViewModel = LibraryViewModel()
    fileprivate(set) var player: MPMusicPlayerController
    private let columns: [GridItem] = [GridItem(.flexible(), spacing: 20, alignment: .center),
                               GridItem(.flexible(), spacing: 20, alignment: .center)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(0 ..< libraryViewModel.getAlbumsCount(), id: \.self) { index in
                    NavigationLink(destination: AlbumDetailView(album: libraryViewModel.getAlbum(at: index), player: player)) {
                        
                        makeGridAlbumItem(index: index, libraryViewModel: libraryViewModel)
                    }
                }
            }
            .navigationTitle("라이브러리")
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        .onAppear {
            libraryViewModel.refreshAlbums()
            if UserDefaults.standard.array(forKey: "queueDefault") == nil || player.nowPlayingItem == nil {
                if libraryViewModel.getAlbumsCount() > 0 {
                    player.setQueue(with: MPMediaQuery.songs())
                    player.prepareToPlay()
                    player.skipToBeginning()
                }
            }
        }
    }
}

struct makeAlbumItemContents: View {
    let index: Int
    @StateObject var libraryViewModel: LibraryViewModel
    
    var body: some View {
        VStack{
            Image(uiImage: libraryViewModel.getAlbum(at: index).artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            VStack {
                Text(libraryViewModel.getAlbum(at: index).title)
                    .font(AppFont.libraryAlbumTitleFont)
                    .foregroundColor(AppColor.libraryAlbumTitleFontColor)
                    .lineLimit(1)
                Text(libraryViewModel.getAlbum(at: index).artist)
                    .font(AppFont.libraryAlbumArtistFont)
                    .foregroundColor(AppColor.libraryAlbumArtistFontColor)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
        }
        .cornerRadius(20)
    }
}

struct makeGridAlbumItem: View {
    let index: Int
    @StateObject var libraryViewModel: LibraryViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 3)
                .frame(minHeight: 100, idealHeight: 200, maxHeight: 350, alignment: .center)
            makeAlbumItemContents(index: index, libraryViewModel: libraryViewModel)
        }
        .padding(5)
    }
}
