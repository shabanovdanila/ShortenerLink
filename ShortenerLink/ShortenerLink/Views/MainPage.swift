//
//  ContentView.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import SwiftUI

struct MainPage: View {
    @State var url1: String = ""
    @State var url2: String = ""
    @State var url3: String = ""
    var body: some View {
        ShortenerView(viewModel: ShortenerLinkViewModel(linkClient: CleanUriClient()), url: $url1, nameOfShortener: "CleanUri")
    }
    
    private struct ShortenerView: View {
        @ObservedObject var viewModel: ShortenerLinkViewModel
        @Binding var url: String
        let nameOfShortener: String
        
        var body: some View {
            VStack {
                Text(nameOfShortener)
                HStack {
                    TextField("Введите url", text: $url)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    Spacer()
                    Button("Convert to short") {
                        viewModel.shortenLink(longUrl: url)
                    }
                }
                .padding()
                if(viewModel.loading) {
                    ProgressView()
                        .padding()
                } else {
                    Text(viewModel.loadedShortLink)
                        .padding()
                }
            }
        }
    }
}
