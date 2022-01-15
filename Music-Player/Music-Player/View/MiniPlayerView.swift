//
//  MiniPlayerView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/15.
//

import SwiftUI
import MediaPlayer

class MiniPlayerViewModel: ObservableObject {
    
}

struct MiniPlayerView: View {
    
    @State var showFullPlayer: Bool = false
    @ObservedObject var playerViewModel = MiniPlayerViewModel()
    @Binding var player: MPMusicPlayerController
    @State var playbackState: MPMusicPlaybackState? = MPMusicPlayerController.applicationMusicPlayer.playbackState
    
    var body: some View {
        VStack {
            if showFullPlayer {
                Spacer()
            }
            VStack() {
                HStack() {
                    
                    if !showFullPlayer {
                        playPauseButton()
                        Spacer()
                        contentInfoText()
                        Spacer()
                    }
                    VStack {
                        if showFullPlayer {
                            contentInfoText()
                            Divider()
                        }
                        Image(uiImage: player.nowPlayingItem?.artwork?.image(at: CGSize(width: 100, height: 100)) ?? UIImage())
                            .resizable()
                            .padding(.top, showFullPlayer ? 50 : 0)
                            .frame(maxWidth: showFullPlayer ? .infinity : 50, maxHeight: showFullPlayer ? .infinity : 50)
                            .aspectRatio(contentMode: .fit)
                            .allowsHitTesting(false)
                            
                    }
                }
                .padding(.bottom)
                if showFullPlayer {
                    makefullPlayerView()
                }
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
            .background(Color.white.onTapGesture {
                withAnimation(Animation.easeOut(duration: 0.3)) {
                    self.showFullPlayer.toggle()
                }
            })
            .cornerRadius(10)
            .shadow(radius: 3)
            .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)){ _ in
                playbackState = MPMusicPlayerController.applicationMusicPlayer.playbackState
            }
        }
    }
    
    //        VStack {
    //            Spacer()
    //            HStack {
    //                Button {
    //                    playbackState == .playing ? pauseSong() : playSong()
    //                } label: {
    //                    playbackState == .playing ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
    //                }
    //                .font(.title)
    //                Spacer()
    //                VStack {
    //                    Text(player.nowPlayingItem?.title ?? undefinedString)
    //                    HStack {
    //                        Text(player.nowPlayingItem?.artist ?? undefinedString)
    //                            .lineLimit(1)
    //                        Text(" ")
    //                        Text(player.nowPlayingItem?.albumTitle ?? undefinedString)
    //                            .lineLimit(1)
    //                    }
    //                }
    //                Spacer()
    //                Image(uiImage: player.nowPlayingItem?.artwork?.image(at: CGSize(width: 100, height: 100)) ?? UIImage())
    //                    .resizable()
    //                    .aspectRatio(contentMode: .fit)
    //                    .frame(maxWidth: 50, maxHeight: 50)
    //            }
    //
    //        }
    //        .background(Color.white)
    //        .shadow(radius: 3)
    //        .padding(.all)
    //    }
    
    private func makefullPlayerView() -> some View {
        VStack{
            HStack {
                Button {
                } label: {
                    Image(systemName: "repeat")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button {
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                playPauseButton()
                Spacer()
                Button {
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                Button {
                } label: {
                    Image(systemName: "shuffle")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }
    
    private func contentInfoText() -> some View {
        VStack(alignment: .center) {
            Text(player.nowPlayingItem?.title ?? "")
            Text(player.nowPlayingItem?.artist ?? "")
                .foregroundColor(.red)
        }
    }
    
    private func playPauseButton() -> some View {
        Button {
            playbackState == .playing ? pauseSong() : playSong()
        } label: {
            (playbackState == .playing ? Image(systemName: "pause.fill") : Image(systemName: "play.fill"))
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }
    
    private func playSong() {
        player.play()
    }
    
    private func pauseSong() {
        player.pause()
    }
}
