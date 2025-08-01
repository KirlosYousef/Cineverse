//
//  MoviesViewController.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import UIKit
import SDWebImage

/// View controller displaying a grid of movies and handling user interactions.
class MoviesViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .systemRed.withAlphaComponent(0.9)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search movies by name"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.rightView?.tintColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7)
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search movies by name",
                                                                             attributes: attributes)
        return searchBar
    }()
    
    // MARK: - Properties
    private let viewModel = MoviesViewModel()
    
    // MARK: - Lifecycle
    /// Called after the controller's view is loaded into memory. Sets up the UI, binds the view model, and fetches movies.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        searchBar.delegate = self
        bindViewModel()
        viewModel.fetchMovies(reset: true)
    }
    
    // MARK: - Setup
    /// Sets up the main UI components and layout constraints.
    private func setupUI() {
        setupNavigationBar()
        setupBackground()
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])
    }
    
    /// Configures the navigation bar appearance and title.
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        title = "Movies"
    }
    
    /// Sets up the background color and gradient for the view.
    private func setupBackground() {
        view.backgroundColor = .black
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Binds the view model's state changes to UI updates.
    private func bindViewModel() {
        viewModel.onMoviesChanged = { [weak self] in
            self?.collectionView.reloadData()
            self?.errorLabel.isHidden = true
        }
        viewModel.onLoadingChanged = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel.onErrorMessageChanged = { [weak self] message in
            if let message = message {
                self?.errorLabel.text = message
                self?.errorLabel.isHidden = false
            } else {
                self?.errorLabel.isHidden = true
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    /// Returns the number of items (movies) in the given section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: The index number of the section.
    /// - Returns: The number of items in the section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    /// Returns the configured cell for the given index path.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured UICollectionViewCell.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        cell.setFavorite(viewModel.isFavorite(movieId: movie.id))
        cell.onFavoriteTapped = { [weak self] movieId in
            self?.viewModel.toggleFavorite(movieId: movieId)
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    /// Returns the size for the item at the specified index path.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting the size.
    ///   - collectionViewLayout: The layout object requesting the size.
    ///   - indexPath: The index path of the item.
    /// - Returns: The size for the item.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let spacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width - padding - spacing
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.6 // Taller aspect ratio for movie posters
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    /// Handles selection of a movie cell and navigates to the details screen.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view informing the delegate about the new selection.
    ///   - indexPath: The index path of the selected item.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.item]
        let detailsViewModel = MovieDetailsViewModel(movie: movie)
        let detailsVC = MovieDetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight * 1.5 {
            // Near the bottom, load next page
            if let visibleIndexPaths = collectionView.indexPathsForVisibleItems.sorted(by: { $0.item > $1.item }).first {
                viewModel.loadNextPageIfNeeded(currentIndex: visibleIndexPaths.item)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchQuery(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
