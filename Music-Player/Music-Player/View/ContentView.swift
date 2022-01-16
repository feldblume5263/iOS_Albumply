//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

class AuthViewModel: ObservableObject {
    @Published var authStatus: Bool = false
    
    init() {
        getAuthrization()
    }
    
    func getAuthrization()  {
        DispatchQueue.main.async {
            let status = MPMediaLibrary.authorizationStatus()
            if(status == MPMediaLibraryAuthorizationStatus.authorized){
                self.authStatus = true
            }else{
                MPMediaLibrary.requestAuthorization() { status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            self.authStatus = true
                        }else{
                            self.authStatus = false
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    
    @State private var player = MPMusicPlayerController.applicationMusicPlayer
    @State var isPlaying = false
    @State var isFullPlayer: Bool = false
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.authStatus {
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
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
