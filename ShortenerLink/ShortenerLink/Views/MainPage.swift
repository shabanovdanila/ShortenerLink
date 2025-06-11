//
//  ContentView.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import SwiftUI

struct MainPage: View {
    @Environment(\.dependencies) private var dependencies
    @State var urlInput1: String = ""
    @State var urlInput2: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ShortenerView(
                    viewModel: ShortenerLinkViewModel(linkClient: dependencies.goTinyClient),
                    url: $urlInput1,
                    nameOfShortener: "GoTiny",
                    accentColor: .purple
                )
                
                ShortenerView(
                    viewModel: ShortenerLinkViewModel(linkClient: dependencies.cleanUriClient),
                    url: $urlInput2,
                    nameOfShortener: "CleanUri",
                    accentColor: .blue
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private struct ShortenerView: View {
        @ObservedObject var viewModel: ShortenerLinkViewModel
        @Binding var url: String
        let nameOfShortener: String
        let accentColor: Color
        
        @State private var showingError = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Text(nameOfShortener)
                        .font(.title2.bold())
                        .foregroundColor(accentColor)
                    
                    Spacer()
                    
                    if viewModel.loading {
                        ProgressView()
                    }
                }
                
                // Input field
                TextField("Paste URL here", text: $url)
                    .textFieldStyle(RoundedTextFieldStyle(accentColor: accentColor))
                
                // Convert button
                Button(action: convertAction) {
                    Text("Convert to Short URL")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(accentColor: accentColor))
                .disabled(viewModel.loading)
                
                // Result or error
                if !viewModel.loadedShortLink.isEmpty {
                    ResultView(
                        text: viewModel.loadedShortLink,
                        isError: false,
                        accentColor: accentColor
                    )
                } else if showingError {
                    ResultView(
                        text: "Failed to get short link",
                        isError: true,
                        accentColor: accentColor
                    )
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        
        private func convertAction() {
            showingError = false
            viewModel.shortenLink(longUrl: url)
        }
    }
    
    // MARK: - Custom Views
    
    private struct RoundedTextFieldStyle: TextFieldStyle {
        var accentColor: Color
        
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(12)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(accentColor.opacity(0.3), lineWidth: 1)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
    
    private struct PrimaryButtonStyle: ButtonStyle {
        var accentColor: Color
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(accentColor)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        }
    }
    
    private struct ResultView: View {
        let text: String
        let isError: Bool
        let accentColor: Color
        
        var body: some View {
            HStack {
                Image(systemName: isError ? "exclamationmark.triangle.fill" : "link")
                    .foregroundColor(isError ? .red : accentColor)
                
                Text(text)
                    .foregroundColor(isError ? .red : .primary)
                
                if !isError {
                    Spacer()
                    Button(action: copyToClipboard) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(accentColor)
                    }
                }
            }
            .padding()
            .background(isError ? Color.red.opacity(0.1) : accentColor.opacity(0.1))
            .cornerRadius(8)
        }
        
        private func copyToClipboard() {
            UIPasteboard.general.string = text
        }
    }
}
