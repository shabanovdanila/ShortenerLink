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
    private var connectionManager: ConnectionManager
    
    init(linkClient: LinkClient, connectionManager: ConnectionManager) {
        self.linkClient = linkClient
        self.connectionManager = connectionManager
        
        self.connectionManager.callback = onPathUpdate
        self.connectionManager.startMonitoring()
    }
    
    private func onPathUpdate(status: Bool) {
        isConnected = status
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if self.isConnected {
                if !self.loadedShortLink.isEmpty {
                    return
                }
            } else {
                self.loadedShortLink = ""
                self.cancellables.removeAll()
                
                self.error = URLError(.notConnectedToInternet)
                self.loadedShortLink = "No internet connection"
                self.loading = false
            }
        }
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
