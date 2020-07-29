//
//  NewsDetailsNewsDetailsViewController.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Nuke
import UIKit

class NewsDetailsViewController: UIViewController {
    var output: NewsDetailsViewOutput!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var networkWarningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.warningIcon()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var fullScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    var article: NewsEntity?
    var articleDetails: [ArticleDetailEntity]?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: - Configuration
    
    private func config() {
        configArticleImage()
        configScrollView()
    }
    
    private func configScrollView() {
        scrollView.canCancelContentTouches = true
    }
    
    private func configArticleImage() {
        articleImageView.clipsToBounds = true
        placeholderView.clipsToBounds = true
        articleImageView.layer.cornerRadius = Constants.articleImageViewCornerRadius
        placeholderView.layer.cornerRadius = Constants.articleImageViewCornerRadius
        articleImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        placeholderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        articleImageViewHeightConstraint.constant = view.frame.height * Constants.articleImageViewHeightMultiplier //высота = 59% от высоты экрана
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let article = article {
            output.actionSaveButtonTapped(article: article, articleDetails: articleDetails ?? [])
        }
    }
    
    @IBAction func actionShareArticle(_ sender: UIButton) {
        guard let url = URL(string: article?.link ?? "") else {
            return
        }
        let urlToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func actionScrollToTop(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    // MARK: - Private
    
    private func setupAtricle() {
        if let article = article {
            loadArticleImage(imageURL: article.imageURL, view: articleImageView)
            logoImageView.image = UIImage(named: article.sourceImageName)
            sourceLabel.text = article.source
            dateLabel.text = article.publishDate.setDateFormat()
            titleLabel.text = article.title
            
            if article.isSaved {
                saveButton.setImage(R.image.bookmarkAct(), for: .normal)
            } else {
                saveButton.setImage(R.image.bookmark(), for: .normal)
            }
        }
    }
    
    private func setArticleDetails(details: [ArticleDetailEntity]) {
        for detail in details {
            switch detail {
            case .imageDetail(let url):
                self.createImageView(with: url)
                
            case .textDetail(let text):
                self.createLabel(with: text, Constants.Font.text.rawValue, Constants.Color.text.rawValue)
                
            case .headingDetail(let text):
                self.createLabel(with: text, Constants.Font.heading.rawValue, .white)
                
            case .imageCaptionDetail(let text):
                self.createLabel(with: text, Constants.Font.imageCaption.rawValue, Constants.Color.imageCaption.rawValue)
            }
        }
    }
    
    private func createLabel(with text: String, _ font: UIFont, _ textColor: UIColor) {
        let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.font = font
            label.textColor = textColor
            setLineSpacing(text: text, for: label, withLineSpacing: Constants.labelLineSpacing)
            label.text = text
            label.sizeToFit()
            return label
        }()
        
        if label.text?.count ?? 0 > Constants.minimumLabelTextCount {
            stackView.addArrangedSubview(label)
        }
    }
    
    private func setLineSpacing(text: String, for label: UILabel, withLineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = withLineSpacing
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attrString.length))
        label.attributedText = attrString
    }
    
    private func createImageView(with imageURL: String) {
        guard imageURL != article?.imageURL else {
            return
        }
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = Constants.articleDetailsImageCornerRadius
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)
            return imageView
        }()
        
        stackView.addArrangedSubview(imageView)
        loadImage(imageURL: imageURL, view: imageView)
    }
    
    private func loadImage(imageURL: String, view: UIImageView) {
        guard let url = URL(string: imageURL) else {
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
            case .success(let response):
                let imageSize = response.image.size
                guard imageSize.height > 50 else {
                    view?.removeFromSuperview()
                    return
                }
                let imageHeight = self.calculateImageHeight(from: imageSize)
                view?.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
                
            case .failure(let error):
                guard let imageSize = R.image.imageNotFound()?.size else {
                    return
                }
                let imageHeight = self.calculateImageHeight(from: imageSize)
                view?.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
                print("Error image loading - \(error.localizedDescription)")
            }
        }
    }
    
    private func loadArticleImage(imageURL: String, view: UIImageView) {
        guard let url = URL(string: imageURL) else {
            return
        }
        
        Nuke.loadImage(with: url, into: view)
        let options = ImageLoadingOptions(
            placeholder: R.image.placeholder(),
            transition: .fadeIn(duration: Constants.animationDuration),
            failureImage: R.image.imageNotFound()
        )
        
        Nuke.loadImage(with: url, options: options, into: view, progress: nil) { result in
            switch result {
            case .success:
                break
                
            case .failure(let error):
                print("Error image loading - \(error.localizedDescription)")
            }
        }
    }
    
    private func calculateImageHeight(from size: CGSize) -> CGFloat {
        let width: CGFloat = view.frame.width - 2 * Constants.imageViewInset
        let height: CGFloat = width / size.width * size.height
        return height
    }
    
    private func showWarning() {
        UIView.transition(with: networkWarningImageView, duration: Constants.animationDuration, options: [.transitionCrossDissolve], animations: {
            self.stackView.insertArrangedSubview(self.networkWarningImageView, at: 2)
        }, completion: nil)
        networkWarningImageView.alpha = 1.0
        networkWarningImageView.widthAnchor.constraint(equalToConstant: Constants.warningImageViewWidth).isActive = true
        networkWarningImageView.heightAnchor.constraint(equalToConstant: Constants.warningImageViewHeight).isActive = true
    }
    
    private func hideWarning() {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.networkWarningImageView.alpha = 0.0
        }) { _ in
            self.networkWarningImageView.removeFromSuperview()
        }
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: Constants.fastAnimationDuration, animations: {
            self.fullScreenImageView.alpha = 0
        }) { _ in
            self.fullScreenImageView.removeFromSuperview()
        }
    }
    
    @objc
    private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        UIView.transition(with: view, duration: Constants.fastAnimationDuration, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.fullScreenImageView)
        }, completion: nil)
        
        fullScreenImageView.image = imageView.image
        fullScreenImageView.alpha = 1.0
        fullScreenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        fullScreenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        fullScreenImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        fullScreenImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
    }
}

// MARK: - Extension UIScrollViewDelegate

extension NewsDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < Constants.minimumContentOffsetForDismiss {
            output.actionBack()
        }
        
        if scrollView.contentOffset.y > articleImageView.frame.maxY {
            UIView.animate(withDuration: Constants.fastAnimationDuration) {
                self.upButton.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: Constants.fastAnimationDuration) {
                self.upButton.alpha = 0.0
            }
        }
    }
}

// MARK: - NewsDetailsViewInput

extension NewsDetailsViewController: NewsDetailsViewInput {
    func showNetworkWarning() {
        activityIndicator.stopAnimating()
        if articleDetails == nil {
            showWarning()
        }
    }
    
    func hideNetworkWarning() {
        hideWarning()
        if articleDetails == nil {
            activityIndicator.startAnimating()
        }
    }
    
    func setupInitialState(article: NewsEntity) {
        self.article = article
        setupAtricle()
    }
    
    func updateArticle(article: NewsEntity) {
        self.article = article
        setupAtricle()
    }
    
    func setupArticleDetails(articleDetails: [ArticleDetailEntity]) {
        self.articleDetails = articleDetails
        setArticleDetails(details: articleDetails)
        activityIndicator.stopAnimating()
        hideWarning()
    }
}
