//
//  Bitly.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation
import Combine

struct GoTinyClient: LinkClient {
    
    private let baseURL: String
    
    init(baseURL: String = "https://gotiny.cc/api") {
        self.baseURL = baseURL
    }
    
    func getShortLink(for url: String) -> AnyPublisher<String, Error> {
        
        let normalizedURL = normalizedURL(for: url)
        
        guard let apiURL = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let requestBody = ["input": normalizedURL]
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Status Code:", httpResponse.statusCode)
                if !(200...299).contains(httpResponse.statusCode) {
                    if let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                        throw NSError(domain: "GoTinyClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.error])
                    }
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: GoTinyResponseLink.self, decoder: JSONDecoder())
            .map { response in
                "https://gotiny.cc/\(response.code)"
            }
            .eraseToAnyPublisher()
    }
}
