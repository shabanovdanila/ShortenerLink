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
    
    private let linkClient: LinkClient
    private var cancellables = Set<AnyCancellable>()
    
    
    init(linkClient: LinkClient) {
        self.linkClient = linkClient
    }
    
    func shortenLink(longUrl: String) {
        loading = true
        
        linkClient.getShortLink(for: longUrl)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] shortUrl in
                self?.loadedShortLink = shortUrl
            })
            .store(in: &cancellables)
        loading = false
    }
}
