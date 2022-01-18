//
//  AuthViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/17.
//

import SwiftUI
import MediaPlayer

enum AuthStatus {
    case notYetDetermined // 권한 미정(초기값)
    case permitted // 권한 수락 - 앱 로드
    case notPermitted // 권한 거절 - 설정 창으로 이동
}

final class AuthViewModel: ObservableObject {
    @Published private(set) var authStatus: AuthStatus = .notYetDetermined
    
    init() {
        getAuthrization()
    }
    
    private func getAuthrization()  {
        let status = MPMediaLibrary.authorizationStatus()
        if (status == MPMediaLibraryAuthorizationStatus.authorized) {
            self.authStatus = .permitted
        } else {
            MPMediaLibrary.requestAuthorization() { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.authStatus = .permitted
                    } else {
                        self.authStatus = .notPermitted
                    }
                }
            }
        }
    }
}
