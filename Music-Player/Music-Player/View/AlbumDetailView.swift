//
//  AlbumDetailView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailView: View {
    var player: MPMusicPlayerController
    @StateObject var albumDetail: AlbumDetailViewModel
    @State var waitingForPrepare: Bool = false
    
    init(album: Album, player: MPMusicPlayerController) {
        _albumDetail = StateObject(wrappedValue: AlbumDetailViewModel(album: album))
        self.player = player
    }
    
    var body: some View {
        VStack {
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
                            .frame(maxWidth: 200, alignment: .leading)
                        Text(albumDetail.album.albumArtist)
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
                        if !waitingForPrepare {
                            allSongsPlayButtonPressed(isShuffle: false)
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
                        if !waitingForPrepare {
                            allSongsPlayButtonPressed(isShuffle: true)
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
                    if !waitingForPrepare {
                        specificSongPlayButtonPressed(songIndex: songIndex)
                    }
                })
            }
        }
        .padding(.bottom, 80)
        .background(Color.white)
        .onAppear {
            initSongsInAlbum()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func initSongsInAlbum() {
        albumDetail.setSongsInAlbumDetail(albumTitle: albumDetail.album.albumTitle)
    }
    
    private func allSongsPlayButtonPressed(isShuffle: Bool) {
        waitingForPrepare = true
        player.stop()
        albumDetail.setIDsQueue()
        let IDsQueue = albumDetail.songIDsQueue
        player.setQueue(with: IDsQueue)
        UserDefaults.standard.set(IDsQueue, forKey: "queueDefault")
        if isShuffle {
            player.shuffleMode = MPMusicShuffleMode.songs
            UserDefaults.standard.set(true, forKey: "shuffleDefault")
            player.shuffleMode = MPMusicShuffleMode.songs
        } else {
            UserDefaults.standard.set(false, forKey: "shuffleDefault")
            player.shuffleMode = MPMusicShuffleMode.off
        }
        player.play()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
            waitingForPrepare = false
        }
    }
    
    private func specificSongPlayButtonPressed(songIndex: Int) {
        waitingForPrepare = true
        albumDetail.setIDsQueue()
        let IDsQueue = albumDetail.songIDsQueue
        player.setQueue(with: IDsQueue)
        UserDefaults.standard.set(IDsQueue, forKey: "queueDefault")
        player.play()
        player.nowPlayingItem = albumDetail.albumContents?.songs[songIndex]
        UserDefaults.standard.set(false, forKey: "shuffleDefault")
        player.shuffleMode = MPMusicShuffleMode.off
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
            waitingForPrepare = false
        }
    }
}

