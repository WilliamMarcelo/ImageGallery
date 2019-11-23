//
//  ViewController.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private weak var fullSizeImageView: UIImageView!
    private weak var shadowView: UIView!
    private weak var closeButton: UIButton!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let cellSpacing: CGFloat = 20
    private let networkingService = NetworkingService<PagedResponseModel<ImageModel>>()
    
    private var viewModel: ImageGalleryViewModelProtocol!
    private var currentCellFrame: CGRect?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupSearchController()
        setupCollectionView()
        
        viewModel = ImageGalleryViewModel(delegate: self)
    }
    
    private func setupSearchController() {
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for images"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        
        collectionView.registerNib(for: ImageCollectionViewCell.self)
        collectionView.registerNib(for: LoadingCollectionViewCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
    }
    
    private func loadDataScrollingToTheTop(tag: String? = nil) {
        
        viewModel.getItems(tag: tag)
        
        if viewModel.itemsCount > 0 {
            
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    private func isLoadingCell(_ indexPath: IndexPath) -> Bool {
        
        return indexPath.row == viewModel.itemsCount
    }
    
    private func closeSelectedImage() {
        
        if let currentCellFrame = currentCellFrame {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.shadowView.alpha = 0
                self.fullSizeImageView.frame = currentCellFrame
                
            }, completion: { completed in
                
                self.closeButton.removeFromSuperview()
                self.shadowView.removeFromSuperview()
                self.fullSizeImageView.removeFromSuperview()
            })
        }
    }
    
    @objc private func didTapCloseButton(sender: UIButton) {
        
        closeSelectedImage()
    }
    
    @objc private func didTapShadowWindow(_ sender: UITapGestureRecognizer? = nil) {
        
        closeSelectedImage()
    }
    
    func buildShadowView(with containerView: UIView) {
        
        let shadowView = UIView(frame: .zero)
        containerView.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        shadowView.alpha = 0
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapShadowWindow(_:)))
        shadowView.addGestureRecognizer(tap)
        
        self.shadowView = shadowView
    }
    
    func buildFullSizeImageView(with frame: CGRect, imageModel: ImageModel, containerView: UIView) {
        
        let fullSizeImageView = UIImageView(frame: frame)
        fullSizeImageView.contentMode = .scaleAspectFit
        containerView.addSubview(fullSizeImageView)
        self.fullSizeImageView = fullSizeImageView
        
        fullSizeImageView.setImage(with: imageModel.largeImageURL, placeholder: Asset.placeholder)
    }
    
    func buildCloseButton(with containerView: UIView) {
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton(sender:)), for: .touchUpInside)
        shadowView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant : 50).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        self.closeButton = closeButton
    }
}

extension ImageGalleryViewController: ImageGalleryViewModelDelegate {
    
    func didSuccessGetItemsList() {
        
        collectionView.reloadData()
    }
    
    func didFailGetGetItemsList(error: Error) {
        
        collectionView.showError(viewController: self, error: error, didTapRetryButton: { [weak self] in
            
            self?.viewModel.getMoreItems()
        })
    }
}

extension ImageGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.hasMoreContentToLoad ? viewModel.itemsCount + 1 : viewModel.itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isLoadingCell(indexPath) && viewModel.hasMoreContentToLoad {
            
            return collectionView.dequeueReusableCell(for: indexPath) as LoadingCollectionViewCell
            
        } else {
            
            let imageModel = viewModel.getItem(at: indexPath.row)
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageCollectionViewCell
            cell.configureCell(with: imageModel)
            
            return cell
        }
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if isLoadingCell(indexPath) {
            
            viewModel.getMoreItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isLoadingCell(indexPath),
            let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath),
            let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            
            let currentCellFrame = collectionView.convert(layoutAttributes.frame, to: collectionView.superview)
            self.currentCellFrame = currentCellFrame
            
            buildShadowView(with: currentWindow)
            buildCloseButton(with: shadowView)
            
            let imageModel = viewModel.getItem(at: indexPath.row)
            buildFullSizeImageView(with: currentCellFrame, imageModel: imageModel, containerView: shadowView)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.shadowView.alpha = 1
                self.fullSizeImageView.frame = currentWindow.frame
            })
        }
    }
}

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat!
        let height: CGFloat!
        
        if isLoadingCell(indexPath) {
            
            width = ceil(collectionView.frame.width - cellSpacing * 2)
            height = 50
            
        } else {
            
            width = (collectionView.frame.width / 2) - (cellSpacing + cellSpacing / 2)
            height = width
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellSpacing
    }
}

extension ImageGalleryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        loadDataScrollingToTheTop(tag: searchBar.text)
    }
}
