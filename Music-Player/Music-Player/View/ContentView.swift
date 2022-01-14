//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var songQueue: [MPMediaItem]? = []
    
    var body: some View {
        NavigationView {
            LibraryView(songQueue: $songQueue)
        }
        MiniPlayerView(musicPlayer: $musicPlayer, songQueue: $songQueue)
    }
}


class MiniPlayerViewModel: ObservableObject {
    
    func getSongsIDs(queue: [MPMediaItem]?) -> [String] {
        var stringQueue: [String] = []
        queue?.forEach({ song in
            stringQueue.append(song.playbackStoreID)
        })
        return stringQueue
    }
}

struct MiniPlayerView: View {
    
    @Binding var musicPlayer: MPMusicPlayerController
    @Binding var songQueue: [MPMediaItem]?
    @State var isPlaying = false
    @ObservedObject var playerViewModel = MiniPlayerViewModel()
    @State var songsIDs: [String] = []
    
    var body: some View {
        HStack {
            Button {
                isPlaying.toggle()
                if isPlaying {
                    playQueue()
                } else {
                    stopPlay()
                }
            } label: {
                isPlaying ? Image(systemName: "play.fill") : Image(systemName: "pause.fill")
            }
            Spacer()
            VStack {
                Text("\(songQueue?.count ?? 0)")
                Text("")
            }
            Spacer()
            Image(uiImage: UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 10, maxHeight: 10)
                .background(Color.gray)
        }
        .frame(height: 50)
        .padding()
    }
    
    private func playQueue() {
        songsIDs = playerViewModel.getSongsIDs(queue: songQueue)
        musicPlayer.setQueue(with: songsIDs)
        musicPlayer.play()
    }
    
    private func stopPlay() {
        musicPlayer.pause()
    }
}
