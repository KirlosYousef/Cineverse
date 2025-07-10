//
//  MovieDetailsViewController.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    private let viewModel: MovieDetailsViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        setupNavigationBar()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(detailsContainerView)
        
        detailsContainerView.addSubview(titleLabel)
        detailsContainerView.addSubview(releaseDateLabel)
        detailsContainerView.addSubview(overviewLabel)
        
        // Add blur effect to details container
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        detailsContainerView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            overlayView.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor),
            
            detailsContainerView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -24),
            detailsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: detailsContainerView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -24),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 24),
            releaseDateLabel.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -24),
            
            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 24),
            overviewLabel.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 24),
            overviewLabel.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -24),
            overviewLabel.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton

        title = "Movie Details"
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configure() {
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        releaseDateLabel.text = viewModel.releaseDate
        
        if let url = viewModel.posterURL {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            posterImageView.image = UIImage(systemName: "photo")
            posterImageView.tintColor = .gray
        }
    }
} 
