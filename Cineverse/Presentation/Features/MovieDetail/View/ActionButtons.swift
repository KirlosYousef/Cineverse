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
            }
            .buttonStyle(ActionButtonStyle(backgroundColor: .clear))
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            
            // Share Button
            Button(action: shareAction) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .medium))
                    Text("Share")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(ActionButtonStyle(backgroundColor: .white.opacity(0.15)))
            .accessibilityLabel("Share movie")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}
