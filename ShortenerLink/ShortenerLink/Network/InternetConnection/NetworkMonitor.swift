//
//  NetworkMonitor.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation
import Network

class NetworkMonitor: ConnectionManager {
    var callback: ((Bool) -> Void)?
    
    private let pathMonitor = NWPathMonitor()
    
    init() {
        self.pathMonitor.pathUpdateHandler = onUpdate
    }
    
    func startMonitoring() {
        pathMonitor.start(queue: DispatchQueue.main)
    }
    
    private func onUpdate(path: NWPath) {
        callback?(path.status == .satisfied)
    }
    
}
