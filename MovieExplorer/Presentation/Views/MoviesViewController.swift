//
//  MoviesViewController.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import UIKit

class MoviesViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return collectionView
    }()
    
    // MARK: - Properties
    private var movies: [Movie] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPlaceholderData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Popular Movies"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Placeholder Data
    private func loadPlaceholderData() {
        // Create placeholder movies for UI testing
        movies = [
            Movie(id: 1, title: "Movie title 1", overview: "Movie overview 1", posterPath: nil, releaseDate: "2025-07-10", voteAverage: 9.0),
            Movie(id: 2, title: "Movie title 2", overview: "Movie overview 2", posterPath: nil, releaseDate: "2025-07-10", voteAverage: 9.0),
            Movie(id: 3, title: "Movie title 3", overview: "Movie overview 3", posterPath: nil, releaseDate: "2025-07-10", voteAverage: 9.0)
        ]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let spacing: CGFloat = 10
        let availableWidth = collectionView.bounds.width - padding * 2 - spacing
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.5 // Aspect ratio for movie posters
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        print("Selected movie: \(movie.title)")
        // TODO: Navigate to movie details screen
    }
} 