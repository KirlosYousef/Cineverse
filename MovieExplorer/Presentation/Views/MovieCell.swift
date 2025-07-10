//
//  MovieCell.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "MovieCell"
    
    // MARK: - UI Components
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var movieId: Int?
    var onFavoriteTapped: ((Int) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Poster Image View
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.4),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            // Favorite Button
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Configuration
    func configure(with movie: Movie) {
        movieId = movie.id
        titleLabel.text = movie.title
        
        // Set placeholder image for now
        posterImageView.image = UIImage(systemName: "film")
        posterImageView.tintColor = .systemGray3
        
        // TODO: Load actual poster image using SDWebImage
    }
    
    func setFavorite(_ isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        guard let movieId = movieId else { return }
        onFavoriteTapped?(movieId)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        favoriteButton.isSelected = false
        movieId = nil
        onFavoriteTapped = nil
    }
} 