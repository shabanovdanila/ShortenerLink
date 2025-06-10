//
//  UrlLink.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation

struct CleanUriLink: Codable {
    var url: String
}

struct CleanUriResponseLink: Codable {
    var result_url: String
}
