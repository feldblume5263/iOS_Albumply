//
//  AuthViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/17.
//

import SwiftUI
import MediaPlayer

enum AuthStatus {
    case notYetDetermined
    case permitted
    case notPermitted
}

class AuthViewModel: ObservableObject {
    @Published var authStatus: AuthStatus = .notYetDetermined
    
    init() {
        getAuthrization()
    }
    
    func getAuthrization()  {
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
