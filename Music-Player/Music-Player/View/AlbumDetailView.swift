//
//  AlbumDetailView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailView: View {
    @StateObject var albumDetail: AlbumDetailViewModel
    
    init(album: Album, player: MPMusicPlayerController) {
        _albumDetail = StateObject(wrappedValue: AlbumDetailViewModel(album: album, player: player))
    }
    
    var body: some View {
        VStack {
            AlbumControllView(albumDetail: albumDetail)
                .background(Color.white)
            
            AlbumSongListView(albumDetail: albumDetail)
                .padding(.bottom, 80)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumSongListView: View {
    let albumDetail: AlbumDetailViewModel
    
    var body: some View {
        List {
            ForEach(0 ..< albumDetail.getSongsCount(), id: \.self) { songIndex in
                HStack {
                    Text("\(songIndex + 1)")
                        .frame(minWidth: 10, idealWidth: 15, maxWidth: 30)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    Text(albumDetail.albumContents?.songs[songIndex].title ?? undefinedString)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundColor(mainColor)
                }
                .frame(height: 40)
                .background(Color.white .onTapGesture {
                    if !albumDetail.waitingForPrepare {
                        albumDetail.specificSongPlayButtonPressed(songIndex: songIndex)
                    }
                })
            }
        }
    }
}

struct AlbumControllView: View {
    let albumDetail: AlbumDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: albumDetail.album.artwork)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                VStack(alignment: .leading, spacing: 0) {
                    Text(albumDetail.album.title)
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                        .frame(maxWidth: 200, alignment: .leading)
                    Text(albumDetail.album.artist)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                        .frame(maxWidth: 200, alignment: .leading)
                    Spacer()
                    
                }
                .padding(.top, 25)
                .padding(.bottom)
                Spacer()
            }
            .fixedSize()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing)
            Divider()
            HStack {
                Spacer()
                Button {
                    if !albumDetail.waitingForPrepare {
                        albumDetail .allSongsPlayButtonPressed(isShuffle: false)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 40, alignment: .center)
                            .foregroundColor(subColor)
                        Image(systemName: "play.fill")
                            .foregroundColor(mainColor)
                            .font(.headline)
                    }
                }
                Spacer()
                Button {
                    if !albumDetail.waitingForPrepare {
                        albumDetail.allSongsPlayButtonPressed(isShuffle: true)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 40, alignment: .center)
                            .foregroundColor(subColor)
                        Image(systemName: "shuffle")
                            .foregroundColor(mainColor)
                            .font(.headline)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

