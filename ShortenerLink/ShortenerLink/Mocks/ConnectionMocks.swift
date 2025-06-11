//
//  ConnectionMocks.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation

struct GoodConnection: ConnectionManager {
    var callback: ((Bool) -> Void)?
    
    func startMonitoring() {
        callback?(true)
    }
}

struct BadConnection: ConnectionManager {
    var callback: ((Bool) -> Void)?
    
    func startMonitoring() {
        callback?(false)
    }
}
