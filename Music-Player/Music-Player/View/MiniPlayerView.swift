//
//  MiniPlayerView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/15.
//

import SwiftUI
import MediaPlayer
import Combine


struct MiniPlayerView: View {
    @StateObject var playerViewModel = MiniPlayerViewModel()
    var player: MPMusicPlayerController
    @Binding var isFullPlayer: Bool
    @State private var playbackState: MPMusicPlaybackState? = MPMusicPlayerController.applicationMusicPlayer.playbackState
    @State private var progressRate:Double = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack {
            
            if isFullPlayer {
                Spacer()
            }
            VStack() {
                if !isFullPlayer {
                    let currentRate = progressRate > playerViewModel.nowPlayingSong.totalRate ?  playerViewModel.nowPlayingSong.totalRate : progressRate
                    ProgressView(value: currentRate < 0 ? currentRate * -1: currentRate, total: playerViewModel.nowPlayingSong.totalRate)
                        .padding(EdgeInsets(top: -20, leading: -10, bottom: -20, trailing: -10))
                        .progressViewStyle(LinearProgressViewStyle(tint: mainColor))
                        .onReceive(timer) { _ in
                            progressRate = player.currentPlaybackTime
                        }
                }
                HStack() {
                    if !isFullPlayer {
                        playPauseButton()
                        Spacer()
                        contentInfoText()
                        Spacer()
                    }
                    VStack {
                        if isFullPlayer {
                            Spacer()
                            HStack {
                                ZStack {
                                    Button {
                                        DispatchQueue.global(qos: .userInteractive).async {
                                            withAnimation(Animation.easeOut(duration: 0.3)) {
                                                self.isFullPlayer.toggle()
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(mainColor)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    contentInfoText()
                                        .frame(width: 300, alignment: .center)
                                }
                            }
                            Divider()
                        }
                        
                        Image(uiImage: playerViewModel.nowPlayingSong.artWork)
                            .resizable()
                            .frame(maxWidth: isFullPlayer ? .infinity : 50, maxHeight: isFullPlayer ? .infinity : 50)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .allowsHitTesting(false)
                            .padding(isFullPlayer ? EdgeInsets(top: 0, leading: -30, bottom: -30, trailing: -30) : EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .padding(.bottom)
                if isFullPlayer {
                    Spacer()
                    makefullPlayerView()
                }
            }
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
            .background(Color.white.onTapGesture {
                if !isFullPlayer {
                    DispatchQueue.global(qos: .userInteractive).async {
                        withAnimation(Animation.easeOut(duration: 0.3)) {
                            self.isFullPlayer.toggle()
                        }
                    }
                }
            })
            .cornerRadius(10)
            .shadow(radius: 3)
            .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)){ _ in
                playbackState = MPMusicPlayerController.applicationMusicPlayer.playbackState
                playbackState?.printState()
            }
            .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)){ _ in
                let song = player.nowPlayingItem
                progressRate = 0.0
                playerViewModel.makeNowPlayingSong(title: song?.title,
                                                   albumeTitle: song?.albumTitle,
                                                   artist: song?.artist,
                                                   artWork: song?.artwork,
                                                   totalRate: player.nowPlayingItem?.playbackDuration)
            }
        }
    }
    
    private func makefullPlayerView() -> some View {
        VStack{
            Spacer()
            HStack {
                Button {
                    player.repeatMode = playerViewModel.changeRepeatMode()
                } label: {
                    switch playerViewModel.repeatMode {
                    case .noRepeat:
                        Image(systemName: "repeat")
                            .font(.headline)
                            .foregroundColor(subColor)
                            .frame(width: 50, height: 50)
                    case .albumRepeat:
                        Image(systemName: "repeat")
                            .font(.headline)
                            .foregroundColor(mainColor)
                            .frame(width: 50, height: 50)
                    case .oneSongRepeat:
                        Image(systemName: "repeat.1")
                            .font(.headline)
                            .foregroundColor(mainColor)
                            .frame(width: 50, height: 50)
                    }
                }
                Spacer()
                Button {
                    if player.currentPlaybackTime > 5 {
                        player.skipToBeginning()
                    } else {
                        player.skipToPreviousItem()
                    }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.headline)
                        .foregroundColor(mainColor)
                        .frame(width: 50, height: 50)
                }
                Spacer()
                playPauseButton()
                Spacer()
                Button {
                    player.skipToNextItem()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.headline)
                        .foregroundColor(mainColor)
                        .frame(width: 50, height: 50)
                }
                Spacer()
                Button {
                    player.shuffleMode = player.shuffleMode == .off ? MPMusicShuffleMode.songs : MPMusicShuffleMode.off
                    playerViewModel.isShuffle = player.shuffleMode == .off ? false : true
                } label: {
                    Image(systemName: "shuffle")
                        .font(.headline)
                        .foregroundColor(player.shuffleMode == .off ? subColor : mainColor)
                        .frame(width: 50, height: 50)
                }
            }
            Spacer()
            VolumeSlider()
                .frame(height: 30)
                .padding(.horizontal)
            Spacer()
            VStack {
                Spacer()
                ZStack {
                    Text(playerViewModel.getTimeFrom(rawValue: (player.nowPlayingItem?.playbackDuration ?? 1) - progressRate, timeLeftMode: true))
                        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                        .font(.caption)
                        .offset(x: 0, y: -10)
                        .font(.caption)
                        .foregroundColor(subColor)
                    Text(playerViewModel.getTimeFrom(rawValue: progressRate, timeLeftMode: false))
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
                        .offset(x: UIScreen.main.bounds.width * progressRate / (player.nowPlayingItem?.playbackDuration ?? 1) - 30, y: -10)
                        .font(.caption)
                        .foregroundColor(mainTextColor)
                }
                ProgressView(value: progressRate < 0 ? progressRate * -1: progressRate, total: player.nowPlayingItem?.playbackDuration ?? 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: mainColor))
                    .padding(EdgeInsets(top: -20, leading: -10, bottom: -20, trailing: -10))
                    .onReceive(timer) { _ in
                        progressRate = player.currentPlaybackTime
                    }
            }
            .fixedSize()
        }
    }
    
    private func contentInfoText() -> some View {
        VStack(alignment: .center) {
            Text(playerViewModel.nowPlayingSong.title)
                .font(.headline)
                .foregroundColor(mainTextColor)
                .lineLimit(1)
            Text(playerViewModel.nowPlayingSong.artist + " ― " + playerViewModel.nowPlayingSong.albumTitle)
                .font(.subheadline)
                .foregroundColor(mainTextColor)
                .lineLimit(1)
        }
    }
    
    private func playPauseButton() -> some View {
        Button {
            DispatchQueue.global(qos: .userInteractive).async {
                playbackState == .playing ? pauseSong() : playSong()
            }
        } label: {
            (playbackState == .playing ? Image(systemName: "pause.fill") : Image(systemName: "play.fill"))
                .font(.title)
                .foregroundColor(mainColor)
                .frame(width: 50, height: 50)
        }
    }
    
    private func playSong() {
        player.play()
    }
    
    private func pauseSong() {
        player.pause()
    }
}

struct VolumeSlider: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        
        let view = MPVolumeView(frame: .zero)
        let subViews = view.subviews
        for current in subViews {
            if current.isKind(of: UISlider.self) {
                let tempSlider = current as! UISlider
                tempSlider.minimumTrackTintColor = mainUIColor
                tempSlider.maximumTrackTintColor = subUIColor
                return current
            }
        }
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}
