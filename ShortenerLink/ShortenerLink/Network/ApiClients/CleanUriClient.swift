//
//  LinkClient.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation
import Combine

struct CleanUriClient: LinkClient {
    
    func getShortLink(for url: UrlLink) -> AnyPublisher<String, Error> {
        guard let apiURL = URL(string: "https://cleanuri.com/api/v1/shorten") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard let encodedURL = url.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let postData = "url=\(encodedURL)".data(using: .utf8) else {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                        throw NSError(domain: "LinkClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.error])
                    }
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ServerResponseUrlLink.self, decoder: JSONDecoder())
            .map(\.result_url)
            .eraseToAnyPublisher()
    }
}
