//
//  NewsNewsViewController.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Nuke
import UIKit

class NewsViewController: UIViewController {
    var output: NewsViewOutput!
    @IBOutlet weak var collectionView: NewsCollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var allNewsButton: UIButton!
    @IBOutlet weak var savedNewsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var networkWarningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.warningIcon()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var newsEntity: [NewsEntity]?
    var articleIndex: CGFloat = 2.0
    var isAllNewsShows = true
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: - Configuration
    
    private func config() {
        configCollectionView()
        configTapGesture()
        configActivityIndicator()
    }
    
    private func configCollectionView() {
        let layout = NewsCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delaysContentTouches = false
        collectionView.invisibleScrollView.delegate = self
    }
    
    private func configTapGesture() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.collectionView.invisibleScrollView.addGestureRecognizer(touchGesture)
    }
    
    private func configActivityIndicator() {
        stackView.setCustomSpacing(Constants.stackViewSpacing, after: activityIndicator)
    }
    
    @IBAction func actionShowAllNews(_ sender: UIButton) {
        setButtons(firstButton: allNewsButton, secondButton: savedNewsButton)
        isAllNewsShows = true
        newsEntity = []
        collectionView.reloadData()
        output.actionShowAllNews()
    }
    
    @IBAction func actionShowSavedNews(_ sender: UIButton) {
        setButtons(firstButton: savedNewsButton, secondButton: allNewsButton)
        isAllNewsShows = false
        newsEntity = []
        collectionView.reloadData()
        output.actionShowSavedNews()
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        guard let indexPath = collectionView.currentCenterCellIndex else {
            return
        }
        guard let selectedArticle = newsEntity?[indexPath.row] else {
            return
        }
        output.actionSelectArticle(article: selectedArticle)
    }
    
    // MARK: - Private
    
    private func scrollToBeginOfCollection() {
        guard let newsCount = newsEntity?.count else {
            return
        }
        if newsCount >= 3 {
            collectionView.invisibleScrollView.contentOffset = CGPoint(
                x: 2.0 * (view.frame.size.width - (2 * Constants.collectionViewInset)),
                y: 0
            )
        }
    }
    
    private func setButtons(firstButton: UIButton, secondButton: UIButton) {
        firstButton.tintColor = .white
        firstButton.isUserInteractionEnabled = false
        secondButton.tintColor = UIColor.white.withAlphaComponent(0.4)
        secondButton.isUserInteractionEnabled = true
    }
    
    private func scrollToPreviousArticle() {
        collectionView.invisibleScrollView.contentOffset = CGPoint(
            x: (articleIndex) * (view.frame.size.width - (2 * Constants.collectionViewInset)),
            y: 0
        )
    }
    
    private func loadImage(imageURL: String, view: UIImageView) {
        guard let url = URL(string: imageURL) else {
            view.image = R.image.imageNotFound()
            return
        }
        
        let options = ImageLoadingOptions(
            placeholder: R.image.placeholder(),
            transition: .fadeIn(duration: Constants.animationDuration),
            failureImage: R.image.imageNotFound()
        )
        
        let request = ImageRequest(url: url)
        Nuke.loadImage(with: request, options: options, into: view, progress: nil) { [weak view] result in
            switch result {
            case .success(let responce):
                view?.image = responce.image
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showNetworkWarning() {
        stackView.insertArrangedSubview(networkWarningImageView, at: 0)
        stackView.setCustomSpacing(Constants.stackViewSpacing, after: networkWarningImageView)
        networkWarningImageView.alpha = 1
        networkWarningImageView.widthAnchor.constraint(equalToConstant: Constants.warningImageViewWidth).isActive = true
        networkWarningImageView.heightAnchor.constraint(equalToConstant: Constants.warningImageViewHeight).isActive = true
    }
    
    private func hideNetworkWarning() {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.networkWarningImageView.alpha = 0
        }) { _ in
            self.networkWarningImageView.removeFromSuperview()
        }
    }
    
    func setLineSpacing(text: String, for label: UILabel, withLineSpacing: CGFloat, alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = withLineSpacing
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attrString.length))
        label.attributedText = attrString
        label.textAlignment = alignment
        label.lineBreakMode = .byTruncatingTail
    }
}

// MARK: - Extensions UICollectionView

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsEntity?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewsCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.newsCollectionViewCell,
                                                                               for: indexPath)
        
        if let articleEntity = newsEntity?[indexPath.row] {
            cell.sourceImageView.image = UIImage(named: "\(articleEntity.sourceImageName)")
            cell.sourceLabel.text = articleEntity.source
            cell.dateLabel.text = articleEntity.publishDate.setDateFormat()
            cell.titleLabel.text = articleEntity.title
            setLineSpacing(text: articleEntity.description, for: cell.descriptionLabel, withLineSpacing: Constants.labelLineSpacing, alignment: .left)
        }
        
        loadImage(imageURL: newsEntity?[indexPath.row].imageURL ?? "", view: cell.articleImageView)
        
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.didScroll()
        let itemWidth = view.frame.size.width - (2 * Constants.collectionViewInset)
        guard let itemsCount = newsEntity?.count else {
            return
        }
        let leftLimit: CGFloat = 2.0 * itemWidth
        let rightLimit: CGFloat = CGFloat(itemsCount - 2) * itemWidth
        
        if itemsCount >= 3 {
            switch collectionView.contentOffset.x {
            case rightLimit...:
                let currentOffset = collectionView.invisibleScrollView.contentOffset.x
                let difference = currentOffset - rightLimit
                let offset = CGPoint(x: leftLimit + difference, y: 0)
                collectionView.invisibleScrollView.contentOffset = offset
                collectionView.contentOffset = offset
                
            case ...itemWidth:
                let currentOffset = collectionView.invisibleScrollView.contentOffset.x
                let difference = itemWidth - currentOffset
                let offset = CGPoint(x: rightLimit - itemWidth - difference, y: 0)
                collectionView.invisibleScrollView.contentOffset = offset
                collectionView.contentOffset = offset
                
            default:
                break
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.currentCenterCellIndex else {
            return
        }
        if isAllNewsShows {
            articleIndex = CGFloat(indexPath.row)
        }
        print(indexPath.row)
    }
}

// MARK: - NewsViewInput

extension NewsViewController: NewsViewInput {
    func failConnection() {
        showNetworkWarning()
        activityIndicator.stopAnimating()
    }
    
    func getConnection() {
        hideNetworkWarning()
        activityIndicator.startAnimating()
    }
    
    func updateNews(news: [NewsEntity]) {
        if isAllNewsShows {
            newsEntity = news
            collectionView.reloadData()
        } else {
            collectionView.reloadData()
        }
    }
    
    func setupSavedNews(news: [NewsEntity]) {
        if !isAllNewsShows {
            newsEntity = news
            scrollToBeginOfCollection()
            collectionView.reloadData()
        }
    }
    
    func setupInitialState(news: [NewsEntity]) {
        if isAllNewsShows {
            newsEntity = news
            collectionView.reloadData()
            scrollToPreviousArticle()
        }
        activityIndicator.stopAnimating()
    }
}
