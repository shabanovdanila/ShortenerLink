//
//  ConnectionManager.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation

protocol ConnectionManager {
    var callback: ((Bool) -> Void)? { get set }
    func startMonitoring()
}
