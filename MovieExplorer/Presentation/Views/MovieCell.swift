//
//  MovieCell.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "MovieCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    func configure(with movie: Movie) {
        movieId = movie.id
        titleLabel.text = movie.title
        
        posterImageView.image = UIImage(systemName: "film")
        posterImageView.tintColor = .systemGray3
        
        if let url = movie.posterURL {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "film"))
            posterImageView.tintColor = nil
        }
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
