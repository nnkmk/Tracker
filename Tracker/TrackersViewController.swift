import UIKit

class TrackersViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Поиск"
        navigationItem.searchController = search
        
        setupNavigationBar()
        setupPlaceholder()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "Трекеры"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(addTrackerTapped)
            )
    }
    
    private func setupPlaceholder() {
        let placeholderView = makePlaceholderView()
        view.addSubview(placeholderView)
        
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func makePlaceholderView() -> UIView {
        let placeholderView = UIView()
        
        // Настройка изображения
        let imageView = UIImageView(image: UIImage(named: "placeholderImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(imageView)
        
        // Constraints для imageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor, constant: -20), // поднять над центром
            imageView.widthAnchor.constraint(equalToConstant: 100), // предположим, ширина 100
            imageView.heightAnchor.constraint(equalToConstant: 100) // предположим, высота 100
        ])
        
        // Настройка лейбла
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .gray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(placeholderLabel)
        
        // Constraints для placeholderLabel
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8), // отступ от изображения
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor)
        ])
        
        return placeholderView
    }

    
    @objc private func addTrackerTapped() {
        //действие кнопки +
        print("Добавить трекер")

    }
}
