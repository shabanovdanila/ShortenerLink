//
//  NormalizeURL.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation
func normalizedURL(for url: String) -> String{
    let normalizedURL: String
    if !url.lowercased().hasPrefix("http://") && !url.lowercased().hasPrefix("https://") {
        normalizedURL = "https://" + url
    } else {
        normalizedURL = url
    }
    return normalizedURL
}
