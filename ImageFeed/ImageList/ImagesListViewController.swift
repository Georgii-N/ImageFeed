import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    @IBOutlet var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var presenter: ImagesListViewPresenterProtocol?
    var alertPresenter: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let presenter = presenter else { return }
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let fullImageUrl = presenter.didSelectImage(at: indexPath, type: .large)
            self.showImage(vc: viewController, urlString: fullImageUrl)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        let thumbURLString = presenter.didSelectImage(at: indexPath, type: .thumb)
        let url = URL(string: thumbURLString)
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: url, placeholder: Res.Images.ImageList.placeholderCell) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        
        if let date = presenter.dateForSelectedPhoto(at: indexPath) {
            cell.dataLabel.text = dateFormatter.string(from: date)
        }
        let isLike = presenter.isLiked(at: indexPath)
        cell.setIsLiked(isLiked: isLike)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.countOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        if indexPath.row + 1 == presenter.countOfPhotos() {
            presenter.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        guard let presenter = presenter else { return }
        let oldCount = presenter.countOfPhotos()
        let newCount = presenter.countOfPhotosInImageListService()
        presenter.updatePhotos()
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func showImage(vc: SingleImageViewController, urlString: String?) {
        UIBlockingProgressHUD.show()
        guard let fullImageUrl = urlString,
              let url = URL(string: fullImageUrl) else { return }
        vc.singleImageView.kf.setImage(with: url)
        { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                vc.singleImageView.image = imageResult.image
                vc.rescaleAndCenterImageInScrollView(image: vc.singleImageView.image!)
            case .failure:
                self.showError(vc: vc, url: urlString)
            }
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let presenter = presenter else { return }
        presenter.imageListCellDidTapLike(at: indexPath) {isLiked in
            cell.setIsLiked(isLiked: isLiked)
        }
    }
    
    func showError(vc: SingleImageViewController, url: String?) {
        alertPresenter?.presentErrorAlert(vc: self, okAction: {
            [weak self] in
            guard let self = self else { return }
            self.showImage(vc: vc, urlString: url)
        })
    }
    
    func showLoadingIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissLoadingIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}

