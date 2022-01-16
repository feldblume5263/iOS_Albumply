//
//  AlbumDetailView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer
import AVFoundation

struct AlbumDetailView: View {
    var album: Album // Binding작업 필요, ViewModel에서 참조하도록 해야하나??
    @Binding var player: MPMusicPlayerController
    @ObservedObject var albumDetail = AlbumDetailViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: album.albumArtwork)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                VStack {
                    Text(album.albumTitle)
                        .font(.title2)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                    Text(album.albumArtist)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                }
                Spacer()
            }
            Divider()
            HStack {
                Spacer()
                Button {
                    allSongsPlayButtonPressed(isShuffle: false)
                } label: {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color.black)
                }
                .padding()
                Spacer()
                Button {
                    allSongsPlayButtonPressed(isShuffle: true)
                } label: {
                    Image(systemName: "shuffle")
                        .foregroundColor(Color.black)
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        List {
            ForEach(0 ..< albumDetail.getSongsCount(), id: \.self) { songIndex in
                HStack {
                    Text("\(songIndex + 1)")
                        .frame(minWidth: 10, idealWidth: 15, maxWidth: 30)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        .lineLimit(1)
                    Text(albumDetail.albumContents?.songs[songIndex].title ?? undefinedString)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                .onTapGesture {
                    specificSongPlayButtonPressed(songIndex: songIndex)
                }
            }
        }
        .onAppear {
            initSongsInAlbum()
        }
    }
    
    private func initSongsInAlbum() {
        albumDetail.setSongsInAlbumDetail(albumTitle: album.albumTitle)
    }
    
    private func allSongsPlayButtonPressed(isShuffle: Bool) {
        albumDetail.setIDsQueue()
        player.setQueue(with: albumDetail.songIDsQueue)
        if isShuffle {
            player.shuffleMode = MPMusicShuffleMode.songs
        }
        player.play()
    }
    
    private func specificSongPlayButtonPressed(songIndex: Int) {
        albumDetail.setIDsQueue()
        player.setQueue(with: albumDetail.songIDsQueue)
        player.play()
        player.nowPlayingItem = albumDetail.albumContents?.songs[songIndex]
    }
    
}

