//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    private var player = MPMusicPlayerController.applicationMusicPlayer
    @State fileprivate var isFullPlayer: Bool = false
    @ObservedObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.authStatus == .permitted {
            ZStack {
                NavigationView {
                    LibraryView(player: player)
                        .padding(.bottom, 80)
                }
                .edgesIgnoringSafeArea(.bottom)
                BlurView()
                    .opacity(isFullPlayer ? 0.5 : 0.0)
                VStack {
                    Spacer()
                    MiniPlayerView(player: player, isFullPlayer: $isFullPlayer)
                        .frame(minHeight: 450, idealHeight: 600, maxHeight: 750, alignment: .bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarColor(backgroundColor: AppUIColor.mainUIColor, tintColor: .white)
            }
        } else if authViewModel.authStatus == .notPermitted {
            RequestAuthView()
        }
    }
}

struct RequestAuthView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("미디어 및 Apple Music 권한 설정이 필요합니다.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Button("설정창으로 가기") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.subheadline)
            .foregroundColor(.primary)
            Spacer()
        }
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
