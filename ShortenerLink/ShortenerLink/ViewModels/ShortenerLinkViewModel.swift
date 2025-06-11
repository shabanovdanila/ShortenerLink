//
//  ShortenerLinkViewModel.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation
import Combine

final class ShortenerLinkViewModel: ObservableObject {
    @Published var loadedShortLink: String = ""
    @Published var loading: Bool = false
    @Published var error: Error? = nil
    @Published var isConnected = true
    
    private let linkClient: LinkClient
    private var cancellables = Set<AnyCancellable>()
    
    init(linkClient: LinkClient) {
        self.linkClient = linkClient
    }
    
    
    func shortenLink(longUrl: String) {
        guard !longUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            loadedShortLink = "Please enter a URL"
            return
        }
        
        loadedShortLink = ""
        loading = true
        
        linkClient.getShortLink(for: longUrl)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.loading = false
                
                if case .failure(let error) = completion {
                    let errorMessage: String
                    switch error {
                    case URLError.badURL:
                        errorMessage = "Invalid URL format"
                    case URLError.notConnectedToInternet:
                        errorMessage = "No internet connection"
                    case DecodingError.dataCorrupted:
                        errorMessage = "Invalid server response"
                    default:
                        errorMessage = "Failed to shorten URL"
                    }
                    self?.loadedShortLink = errorMessage
                }
            } receiveValue: { [weak self] shortUrl in
                self?.loadedShortLink = shortUrl
            }
            .store(in: &cancellables)
    }
}
