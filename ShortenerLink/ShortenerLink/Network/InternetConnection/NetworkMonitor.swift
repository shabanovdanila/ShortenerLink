//
//  NetworkMonitor.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {

    static let shared = NetworkMonitor()
    @Published var isConnected: Bool = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

extension NetworkMonitor: ConnectionManager {}
