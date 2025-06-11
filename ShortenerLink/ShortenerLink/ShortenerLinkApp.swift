//
//  ShortenerLinkApp.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import SwiftUI

@main
struct ShortenerLinkApp: App {
    
    private let dependencies: AppDependencies = AppDependencies.defaultValue
    
    var body: some Scene {
        WindowGroup {
            MainPage()
                .environment(\.dependencies, dependencies)
                .environmentObject(ConnectionManagerWrapper(NetworkMonitor.shared))
        }
    }
}

