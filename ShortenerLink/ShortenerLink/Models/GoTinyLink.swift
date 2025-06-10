//
//  GoTinyLinj.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation

struct GoTinyLink: Codable {
    var input: String
}

struct GoTinyResponseLink: Codable {
    var code: String
}
