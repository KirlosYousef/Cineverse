//
//  MovieCell.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import UIKit
import SDWebImage

/// Custom collection view cell for displaying a movie poster, title, and favorite button.
class MovieCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    /// The reuse identifier for the cell.
    static let identifier = "MovieCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let detailsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = false
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = false
        return view
    }()
    
    // MARK: - Properties
    /// The unique identifier of the movie displayed in this cell.
    private var movieId: Int?
    /// Closure called when the favorite button is tapped, passing the movie ID.
    var onFavoriteTapped: ((Int) -> Void)?
    
    // MARK: - Initialization
    /// Initializes the cell with the given frame and sets up the UI.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    /// Not implemented. Use init(frame:) instead.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    /// Sets up the UI components and adds them to the cell's content view.
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(detailsContainer)
        detailsContainer.addSubview(blurView)
        detailsContainer.addSubview(titleLabel)
        detailsContainer.addSubview(favoriteButton)
        
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        // Add shadow to the cell
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    /// Sets up layout constraints for the cell's subviews.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            detailsContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            detailsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            detailsContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            detailsContainer.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 8),
            
            favoriteButton.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -12),
            favoriteButton.centerYAnchor.constraint(equalTo: detailsContainer.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            blurView.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: detailsContainer.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    /// Configures the cell with the given movie.
    ///
    /// - Parameter movie: The movie to display in the cell.
    func configure(with movie: Movie) {
        movieId = movie.id
        titleLabel.text = movie.title
        
        let placeholderImage = UIImage(systemName: "film")?.withTintColor(.systemGray3.withAlphaComponent(0.4),
                                                                           renderingMode: .alwaysOriginal)
        posterImageView.sd_setImage(with: movie.posterURL, placeholderImage: placeholderImage)
        
        // Configure accessibility
        setupAccessibility(for: movie)
    }
    
    /// Sets up accessibility properties for the cell and its elements.
    ///
    /// - Parameter movie: The movie to configure accessibility for.
    private func setupAccessibility(for movie: Movie) {
        // Extract year from release date
        let year = String(movie.releaseDate.prefix(4))
        
        // Configure cell accessibility - make the cell the main accessible element
        isAccessibilityElement = true
        accessibilityLabel = "\(movie.title), \(year)"
        accessibilityTraits = [.button]
        accessibilityHint = "Double tap to view movie details"
        accessibilityIdentifier = "movie_cell_\(movie.id)"
        
        // Hide individual elements from accessibility since the cell handles it
        posterImageView.isAccessibilityElement = false
        titleLabel.isAccessibilityElement = false
    }
    
    /// Sets the favorite button's selected state.
    ///
    /// - Parameter isFavorite: Whether the movie is marked as favorite.
    func setFavorite(_ isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
        
        // Update accessibility properties when favorite state changes
        let favoriteState = isFavorite ? "favorited" : "not favorited"
        favoriteButton.accessibilityLabel = "Movie is \(favoriteState)"
        favoriteButton.accessibilityHint = "Double tap to \(isFavorite ? "remove from" : "add to") favorites"
    }
    
    // MARK: - Actions
    /// Handles the favorite button tap event and notifies listeners.
    @objc private func favoriteButtonTapped() {
        guard let movieId = movieId else { return }
        onFavoriteTapped?(movieId)
    }
    
    // MARK: - Reuse
    /// Prepares the cell for reuse by resetting its content and state.
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        favoriteButton.isSelected = false
        movieId = nil
        onFavoriteTapped = nil
        
        // Reset accessibility properties
        accessibilityLabel = nil
        accessibilityHint = nil
        accessibilityIdentifier = nil
        accessibilityTraits = []
    }
}
