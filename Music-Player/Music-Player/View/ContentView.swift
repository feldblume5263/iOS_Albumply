//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @State private var player = MPMusicPlayerController.applicationMusicPlayer
    @State var isPlaying = false
    @State var isFullPlayer: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                LibraryView(player: player)
            }
            BlurView()
                .opacity(isFullPlayer ? 0.5 : 0.0)
            VStack {
                Spacer()
                MiniPlayerView(player: player, isFullPlayer: $isFullPlayer)
                    .frame(minHeight: 450, idealHeight: 600, maxHeight: 750, alignment: .bottom)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
