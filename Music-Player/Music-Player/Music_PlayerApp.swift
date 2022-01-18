//
//  Music_PlayerApp.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

@main
struct Music_PlayerApp: App {
    
    @State var mediaAuth: Bool = false
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
