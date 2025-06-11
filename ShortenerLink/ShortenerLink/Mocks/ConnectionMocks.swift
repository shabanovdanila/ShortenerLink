//
//  ConnectionMocks.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation

struct GoodConnection: ConnectionManager {
    var isConnected: Bool = true
}

struct BadConnection: ConnectionManager {
    var isConnected: Bool = false
}
