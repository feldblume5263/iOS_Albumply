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
    @StateObject var playerViewModel: MiniPlayerViewModel
    @Binding var isFullPlayer: Bool
    
    let timer = Timer.publish(every: 0.5, tolerance: 0.05, on: .main, in: .common).autoconnect()
    
    init(player: MPMusicPlayerController, isFullPlayer: Binding<Bool>) {
        _playerViewModel = StateObject(wrappedValue: MiniPlayerViewModel(player: player))
        self._isFullPlayer = isFullPlayer
    }
    
    var body: some View {
        VStack {
            if isFullPlayer {
                Spacer()
            }
            VStack() {
                if !isFullPlayer {
                    PlayerProgressView(playerViewModel: playerViewModel)
                        .padding(EdgeInsets(top: -20, leading: -10, bottom: -20, trailing: -10))
                        .progressViewStyle(LinearProgressViewStyle(tint: mainColor))
                        .onReceive(timer) { _ in
                            playerViewModel.progressRate = playerViewModel.player.currentPlaybackTime
                        }
                }
                HStack() {
                    if !isFullPlayer {
                        if playerViewModel.player.nowPlayingItem != nil {
                            PlayPauseButton(playerViewModel: playerViewModel)
                        }
                        Spacer()
                        ContentInfoTextView(playerViewModel: playerViewModel)
                        Spacer()
                    }
                    VStack {
                        if isFullPlayer {
                            Spacer()
                            HStack {
                                ZStack {
                                    Button {
                                        withAnimation(Animation.easeOut(duration: 0.3)) {
                                            isFullPlayer.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(mainColor)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    ContentInfoTextView(playerViewModel: playerViewModel)
                                        .frame(width: 300, alignment: .center)
                                }
                            }
                            Divider()
                        }
                        if playerViewModel.player.nowPlayingItem != nil {
                            Image(uiImage: playerViewModel.nowPlayingSong.artWork)
                                .resizable()
                                .frame(maxWidth: isFullPlayer ? .infinity : 50, maxHeight: isFullPlayer ? .infinity : 50)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .allowsHitTesting(false)
                                .padding(isFullPlayer ? EdgeInsets(top: 0, leading: -30, bottom: -30, trailing: -30) : EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                }
                .padding(.bottom)
                if isFullPlayer {
                    Spacer()
                    FullSizePlayerControllerView(playerViewModel: playerViewModel, timer: timer)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
            .background(Color.white.onTapGesture {
                if !isFullPlayer && playerViewModel.player.nowPlayingItem != nil {
                    withAnimation(Animation.easeOut(duration: 0.3)) {
                        isFullPlayer.toggle()
                    }
                }
            })
            .cornerRadius(10)
            .shadow(radius: 3)
            .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)){ _ in
                playerViewModel.playbackState = MPMusicPlayerController.applicationMusicPlayer.playbackState
            }
            .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)){ _ in
                let song = playerViewModel.player.nowPlayingItem
                playerViewModel.progressRate = 0.0
                playerViewModel.makeNowPlayingSong(title: song?.title,
                                                   albumeTitle: song?.albumTitle,
                                                   artist: song?.artist,
                                                   artWork: song?.artwork,
                                                   totalRate: playerViewModel.player.nowPlayingItem?.playbackDuration)
            }
            .onAppear {
                playerViewModel.initPlayerFromUserDefaults()
            }
        }
    }
}


struct ContentInfoTextView: View {
    @StateObject var playerViewModel: MiniPlayerViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            if playerViewModel.player.nowPlayingItem != nil {
                Text(playerViewModel.nowPlayingSong.title)
                    .font(.headline)
                    .foregroundColor(mainTextColor)
                    .lineLimit(1)
                Text(playerViewModel.nowPlayingSong.artist + " ― " + playerViewModel.nowPlayingSong.albumTitle)
                    .font(.subheadline)
                    .foregroundColor(mainTextColor)
                    .lineLimit(1)
            } else {
                Text("앨범을 추가해주세요.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
    }
}


struct PlayPauseButton: View {
    @StateObject var playerViewModel: MiniPlayerViewModel
    
    var body: some View {
        Button {
            playerViewModel.playbackState == .playing ? playerViewModel.player.pause() : playerViewModel.player.play()
        } label: {
            (playerViewModel.playbackState == .playing ? Image(systemName: "pause.fill") : Image(systemName: "play.fill"))
                .font(.title)
                .foregroundColor(mainColor)
                .frame(width: 50, height: 50)
        }
    }
}


struct FullSizePlayerControllerView: View {
    @StateObject var playerViewModel: MiniPlayerViewModel
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    var body: some View {
        VStack{
            Spacer()
            HStack {
                Button {
                    playerViewModel.player.repeatMode = playerViewModel.changeRepeatMode()
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
                    if playerViewModel.player.currentPlaybackTime > 5 {
                        playerViewModel.player.skipToBeginning()
                    } else {
                        playerViewModel.player.skipToPreviousItem()
                    }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.headline)
                        .foregroundColor(mainColor)
                        .frame(width: 50, height: 50)
                }
                Spacer()
                PlayPauseButton(playerViewModel: playerViewModel)
                Spacer()
                Button {
                    playerViewModel.player.skipToNextItem()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.headline)
                        .foregroundColor(mainColor)
                        .frame(width: 50, height: 50)
                }
                Spacer()
                Button {
                    playerViewModel.player.shuffleMode = playerViewModel.player.shuffleMode == .off ? MPMusicShuffleMode.songs : MPMusicShuffleMode.off
                    playerViewModel.isShuffle = playerViewModel.player.shuffleMode == .off ? false : true
                    playerViewModel.isShuffle ? UserDefaults.standard.set(true, forKey: "shuffleDefault") : UserDefaults.standard.set(false, forKey: "shuffleDefault")
                } label: {
                    Image(systemName: "shuffle")
                        .font(.headline)
                        .foregroundColor(playerViewModel.player.shuffleMode == .off ? subColor : mainColor)
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
                    Text(playerViewModel.getTimeFrom(rawValue: (playerViewModel.player.nowPlayingItem?.playbackDuration ?? 1) - playerViewModel.progressRate, timeLeftMode: true))
                        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                        .font(.caption)
                        .offset(x: 0, y: -10)
                        .font(.caption)
                        .foregroundColor(subColor)
                    Text(playerViewModel.getTimeFrom(rawValue: playerViewModel.progressRate, timeLeftMode: false))
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
                        .offset(x: UIScreen.main.bounds.width * playerViewModel.progressRate / (playerViewModel.player.nowPlayingItem?.playbackDuration ?? 1) - 30, y: -10)
                        .font(.caption)
                        .foregroundColor(mainTextColor)
                }
                PlayerProgressView(playerViewModel: playerViewModel)
                    .progressViewStyle(LinearProgressViewStyle(tint: mainColor))
                    .padding(EdgeInsets(top: -20, leading: -10, bottom: -20, trailing: -10))
                    .onReceive(timer) { _ in
                        playerViewModel.progressRate = playerViewModel.player.currentPlaybackTime
                    }
            }
            .fixedSize()
        }
    }
}

struct PlayerProgressView: View {
    @StateObject var playerViewModel: MiniPlayerViewModel
    
    var body: some View {
        let currentRate = playerViewModel.progressRate > playerViewModel.nowPlayingSong.totalRate ?  playerViewModel.nowPlayingSong.totalRate : playerViewModel.progressRate
        ProgressView(value: currentRate < 0 ? currentRate * -1: currentRate, total: playerViewModel.nowPlayingSong.totalRate)
    }
}
