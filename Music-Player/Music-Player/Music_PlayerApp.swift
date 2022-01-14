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
    
    init() {
        authMediaLibrary()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func authMediaLibrary() {
        // user가 auth를 거부하면 앱 사용 못할듯? <- 설정 하라고 설정창으로 보내줄까?
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                print("Success to Get media permission")
            } else {
                print("Fail to get media permission")
                
            }
            
        }
    }
}
