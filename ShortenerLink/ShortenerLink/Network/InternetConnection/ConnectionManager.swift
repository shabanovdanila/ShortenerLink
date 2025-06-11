//
//  ConnectionManager.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation

protocol ConnectionManager {
    var isConnected: Bool { get }
}

final class ConnectionManagerWrapper: ObservableObject {
    @Published var isConnected: Bool
    
    private var connectionManager: ConnectionManager
    
    init(_ connectionManager: ConnectionManager) {
        self.connectionManager = connectionManager
        self.isConnected = connectionManager.isConnected
    }
}
