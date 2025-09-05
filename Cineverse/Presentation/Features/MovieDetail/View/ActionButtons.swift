//
//  ActionButtons.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 06/09/2025.
//


import SwiftUI

struct ActionButtons: View {
    @Binding var isFavorite: Bool
    
    var favoriteAction: () -> Void
    var shareAction: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Favorite Button
            Button(action: favoriteAction) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18, weight: .medium))
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(ActionButtonStyle(backgroundColor: .clear))
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            .accessibilityHint("Double tap to \(isFavorite ? "remove from" : "add to") favorites")
            .accessibilityIdentifier("favorite_button_detail")
            
            // Share Button
            Button(action: shareAction) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .medium))
                    Text("Share")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(ActionButtonStyle(backgroundColor: .white.opacity(0.15)))
            .accessibilityLabel("Share movie")
            .accessibilityHint("Double tap to share movie details")
            .accessibilityIdentifier("share_button_detail")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}
