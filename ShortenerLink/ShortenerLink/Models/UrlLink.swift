//
//  UrlLink.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation

struct UrlLink: Codable {
    var url: String
}

struct ServerResponseUrlLink: Codable {
    var result_url: String
}
