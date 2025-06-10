//
//  LinkClient.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation
import Combine

protocol LinkClient {
    func getShortLink(for url: String) -> AnyPublisher<String, Error>
}
