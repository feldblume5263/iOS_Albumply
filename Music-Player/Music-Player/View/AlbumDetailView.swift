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
    var player: MPMusicPlayerController
    @StateObject var albumDetail: AlbumDetailViewModel
    
    init(album: Album, player: MPMusicPlayerController) {
        _albumDetail = StateObject(wrappedValue: AlbumDetailViewModel(album: album))
        self.player = player
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: albumDetail.album.albumArtwork)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                VStack(alignment: .leading, spacing: 0) {
                    Text(albumDetail.album.albumTitle)
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(albumDetail.album.albumArtist)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Spacer()
            }
            Divider()
            HStack {
                Spacer()
                Button {
                    allSongsPlayButtonPressed(isShuffle: false)
                } label: {
                    ZStack {
                    RoundedRectangle(cornerRadius: 10)
                            .frame(height: 40, alignment: .center)
                            .foregroundColor(Color.gray)
                    Image(systemName: "play.fill")
                        .foregroundColor(Color.black)
                        .font(.headline)
                    }
                }
                Spacer()
                Button {
                    allSongsPlayButtonPressed(isShuffle: true)
                } label: {
                    ZStack {
                    RoundedRectangle(cornerRadius: 10)
                            .frame(height: 40, alignment: .center)
                            .foregroundColor(Color.gray)
                    Image(systemName: "shuffle")
                        .foregroundColor(Color.black)
                        .font(.headline)
                    }
                }
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
        .padding(.bottom, 80)
        .onAppear {
            initSongsInAlbum()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func initSongsInAlbum() {
        albumDetail.setSongsInAlbumDetail(albumTitle: albumDetail.album.albumTitle)
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

