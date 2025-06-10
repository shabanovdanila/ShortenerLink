//
//  ContentView.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import SwiftUI

struct MainPage: View {
    
    @Environment(\.dependencies) private var dependencies
    
    @State var urlInput: String = ""

    var body: some View {
        ShortenerView(viewModel: ShortenerLinkViewModel(linkClient: dependencies.goTinyClient), url: $urlInput, nameOfShortener: "GoTiny")
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
