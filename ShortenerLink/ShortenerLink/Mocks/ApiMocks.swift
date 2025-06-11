//
//  ApiMocks.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 11.06.2025.
//

import Foundation
import Combine

struct EmptyResponseMockClient: LinkClient {
    func getShortLink(for url: String) -> AnyPublisher<String, Error> {
        Just("")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

struct DelayedSuccessMockClient: LinkClient {
    func getShortLink(for url: String) -> AnyPublisher<String, Error> {
        Just("https://mock.short/delayed")
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

struct ErrorMockClient: LinkClient {
    let mockError: Error
    init(mockError: Error = URLError(.notConnectedToInternet)) {
        self.mockError = mockError
    }
    func getShortLink(for url: String) -> AnyPublisher<String, Error> {
        Fail(error: mockError)
            .eraseToAnyPublisher()
    }
}

struct CustomResponsMockClient: LinkClient {
    func getShortLink(for url: String) -> AnyPublisher<String, Error> {
        Just("test_long_long_long.com")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
