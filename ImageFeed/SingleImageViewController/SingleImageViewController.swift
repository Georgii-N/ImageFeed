import UIKit

final class SingleImageViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var backButton = UIButton(type: .custom)
    lazy var singleImageView =  UIImageView()
    private lazy var shareButton = UIButton()
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            singleImageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        self.scrollView.minimumZoomScale = 0.1
        self.scrollView.maximumZoomScale = 1.25
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        configureAppearance()
        addViews()
        constraintViews()
    }
    
    @objc private func didTapShareButton(_ sender: Any) {
        if let image = singleImageView.image {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(vc, animated: true)
        }
    }
    
    @objc private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
}

extension SingleImageViewController {
    private func configureAppearance(){
        scrollView.backgroundColor = Res.Colors.background
        
        backButton.tintColor = .white
        backButton.accessibilityIdentifier = "BackButton"
        backButton.setImage(Res.Images.SingleView.backButton, for: .normal)
        backButton.addTarget(self,
                             action: #selector(didTapBackButton),
                             for: .touchUpInside)
        
        singleImageView.contentMode = .scaleAspectFill
        
        shareButton.setImage(Res.Images.SingleView.shareButton, for: .normal)
        shareButton.addTarget(self,
                              action: #selector(didTapShareButton),
                              for: .touchUpInside)
    }
    
    private func addViews(){
        [scrollView, singleImageView, backButton, shareButton].forEach(self.view.setupView)
    }
    private func constraintViews(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            singleImageView.widthAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor),
            singleImageView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
            
            backButton.topAnchor.constraint(equalTo: singleImageView.topAnchor, constant: 56),
            backButton.leadingAnchor.constraint(equalTo: singleImageView.leadingAnchor, constant: 31),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -51)
        ])
    }
}


