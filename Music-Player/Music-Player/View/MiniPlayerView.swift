//
//  MiniPlayerView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/15.
//

import SwiftUI
import MediaPlayer

enum RepeatMode: CaseIterable {
    case noRepeat
    case albumRepeat
    case oneSongRepeat
}

class MiniPlayerViewModel: ObservableObject {
    @Published var playbackState: MPMusicPlaybackState? = MPMusicPlayerController.applicationMusicPlayer.playbackState
    @Published var repeatMode: RepeatMode = .noRepeat
    
    func changeRepeatMode() -> MPMusicRepeatMode {
        repeatMode = repeatMode.next()
        switch repeatMode {
        case .noRepeat:
            return MPMusicRepeatMode.none
        case .albumRepeat:
            return MPMusicRepeatMode.all
        case .oneSongRepeat:
            return MPMusicRepeatMode.one
        }
    }
}

struct VolumeSlider: UIViewRepresentable {
   func makeUIView(context: Context) -> MPVolumeView {
       MPVolumeView(frame: .zero)
   }
    
   func updateUIView(_ view: MPVolumeView, context: Context) {
       let temp = view.subviews
       for current in temp {
           if current.isKind(of: UISlider.self) {
               let tempSlider = current as! UISlider
               tempSlider.minimumTrackTintColor = .blue
               tempSlider.maximumTrackTintColor = .systemMint
           }
       }
   }
}


struct MiniPlayerView: View {
    @ObservedObject var playerViewModel = MiniPlayerViewModel()
    @Binding var player: MPMusicPlayerController
    @State var showFullPlayer: Bool = false
    @State var playbackState: MPMusicPlaybackState? = MPMusicPlayerController.applicationMusicPlayer.playbackState
    @State var refreshView: Bool = false
    
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
                        Image(uiImage: player.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500)) ?? UIImage())
                            .resizable()
                            .frame(maxWidth: showFullPlayer ? .infinity : 50, maxHeight: showFullPlayer ? .infinity : 50)
                            .aspectRatio(contentMode: .fit)
                            .allowsHitTesting(false)
                            .cornerRadius(10)
                        
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
                playbackState?.printState()
            }
            .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)){ _ in
                refreshView.toggle()
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
                            .font(.title)
                            .foregroundColor(.secondary)
                    case .albumRepeat:
                        Image(systemName: "repeat")
                            .font(.title)
                            .foregroundColor(.black)
                    case .oneSongRepeat:
                        Image(systemName: "repeat.1")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                Button {
                    player.skipToNextItem()
                    refreshView.toggle()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                playPauseButton()
                Spacer()
                Button {
                    player.skipToNextItem()
                    refreshView.toggle()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                Button {
                    player.shuffleMode = player.shuffleMode == .off ? MPMusicShuffleMode.songs : MPMusicShuffleMode.off
                    refreshView.toggle()
                } label: {
                    if refreshView || !refreshView {
                        Image(systemName: "shuffle")
                            .font(.title)
                            .foregroundColor(player.shuffleMode == .off ? .secondary : .black)
                    }
                }
            }
            Spacer()
            VolumeSlider()
               .frame(height: 40)
               .padding(.horizontal)
            Spacer()
        }
    }
    
    private func contentInfoText() -> some View {
        VStack(alignment: .center) {
            if refreshView || !refreshView {
                Text(player.nowPlayingItem?.title ?? "")
                Text(player.nowPlayingItem?.artist ?? "")
                    .foregroundColor(.red)
            }
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