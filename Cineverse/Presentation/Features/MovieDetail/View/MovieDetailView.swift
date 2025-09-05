//
//  MovieDetailView.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import SwiftUI

/// SwiftUI view for displaying detailed information about a selected movie.
struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    @State private var isFavorite: Bool = false
    @State private var showingShareSheet = false
    
    private let favoritesService = DIContainer.shared.favoritesService
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            posterSection(geometry: geometry)
                            
                            detailsSection
                        }
                    }
                }
            }
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Movie Details")
        .navigationBarBackButtonHidden(false)
        .onAppear {
            isFavorite = favoritesService.isFavorite(movieId: viewModel.movie.id)
            
            TelemetryService.shared.send(
                TelemetryService.Signal.movieDetailsViewed,
                payload: [
                    "movieId": String(viewModel.movie.id),
                    "title": viewModel.movie.title
                ]
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [viewModel.movie.title, viewModel.movie.overview])
        }
    }
    
    // MARK: - Poster Section
    private func posterSection(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            // Poster Image
            AsyncImage(url: viewModel.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: geometry.size.height * 0.6)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .clipped()
            .accessibilityLabel("Movie poster for \(viewModel.title)")
            .accessibilityAddTraits(.isImage)
            
            // Dark overlay
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(height: geometry.size.height * 0.6)
                .accessibilityHidden(true)
        }
    }
    
    // MARK: - Details Section
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.title)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel("Movie title: \(viewModel.title)")
                    .accessibilityAddTraits(.isHeader)
                
                Text(viewModel.releaseDate)
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                    .accessibilityLabel("Release date: \(viewModel.releaseDate)")
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.overview)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .accessibilityLabel("Movie overview: \(viewModel.overview)")
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            
            
            ActionButtons(isFavorite: $isFavorite) {
                favoritesService.toggleFavorite(movieId: viewModel.movie.id)
                isFavorite.toggle()
            } shareAction: {
                showingShareSheet = true
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.7))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
        )
        .offset(y: -24)
        .accessibilityElement(children: .contain)
    }
    
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
                .accessibilityLabel("Loading movie details")
            
            Text("Loading movie details...")
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
                .accessibilityHidden(true) // ProgressView already announces loading
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .accessibilityHidden(true)
            
            Text("Error Loading Movie")
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(.white)
                .accessibilityAddTraits(.isHeader)
            
            Text(message)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .accessibilityLabel("Error message: \(message)")
            
            Button(action: {
                // TODO: Implement retry functionality
            }) {
                Text("Try Again")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.8))
                    )
            }
            .accessibilityLabel("Try again")
            .accessibilityHint("Double tap to retry loading the movie details")
            .accessibilityAddTraits(.isButton)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview
#Preview {
    NavigationView {
        MovieDetailView(
            viewModel: MovieDetailsViewModel(
                movie: Movie(
                    id: 1,
                    title: "Sample Movie",
                    overview: "This is a sample movie overview that demonstrates how the text will look in the SwiftUI view. It should wrap properly and maintain good readability.",
                    posterPath: nil,
                    releaseDate: "2024-01-01",
                    voteAverage: 8.5
                )
            )
        )
    }
    .preferredColorScheme(.dark)
}
